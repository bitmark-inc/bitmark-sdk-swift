//
//  Connection.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/26/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import CocoaAsyncSocket

fileprivate struct SocketInfo {
    var connected = false
    let socket: GCDAsyncSocket
}

public class Node: NSObject {
    fileprivate var callbackDic = [String: ([String: Any]) -> Void]()
    fileprivate var socket: GCDAsyncSocket?
    private let queue = DispatchQueue(label: "com.bitmark.nodeconnection", qos: .background)
    
    var connected = false
    let finishConnectionHandler: (() -> Void)
    
    init(url: URL, finishConnectionHandler handler: @escaping () -> Void) {
        finishConnectionHandler = handler
        
        super.init()
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
        
        do {
            try socket?.connect(toHost: url.host!, onPort: UInt16(url.port!))
        }
        catch let e {
            print(e)
        }
    }
    
    public func call(id: String,
                     method: String,
                     params: [String: String]?,
                     timeout: Int = 10,
                     callbackHandler handler:@escaping ([String: Any]) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            var dataDic = [String: Any]()
            dataDic["id"] = id
            dataDic["method"] = method
            dataDic["params"] = params != nil ? [params!] : []
            
            do {
                let data = try JSONSerialization.data(withJSONObject: dataDic, options: .prettyPrinted)
                self.socket?.write(data, withTimeout:-1, tag: 0)
                
                // Add to callback dictionary
                self.callbackDic[id] = handler
                
                // Start reading data
                self.socket?.readData(withTimeout: -1, tag: 0)
            }
            catch {
                print("Convert to json data failed")
            }
        }
    }
}

extension Node: GCDAsyncSocketDelegate {
    
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {

        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                if let id = jsonResult["id"] as? String,
                let result = jsonResult["result"] as? [String: Any] {
                    // Trigger the callback
                    callbackDic[id]?(result)
                }
                else {
                    print("Cannot get id and result from received json")
                }
            }
        }
        catch let e {
            print("Error when parsing received data")
        }
    }
    
    public func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        print("didAcceptNewSocket")
    }
    
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("Socket did connect to host: " + host)
        
        let settings = ["GCDAsyncSocketManuallyEvaluateTrust": NSNumber(value: true),
                        "GCDAsyncSocketSSLPeerName": host as NSString]
        sock.startTLS(settings)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    public func socketDidSecure(_ sock: GCDAsyncSocket) {
        self.connected = true
        finishConnectionHandler()
    }
    
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        finishConnectionHandler()
    }
}



public class Connection {
    public static let shared = Connection()
    fileprivate var nodes = [Node]()
    
    
    public func startConnection(from urls: [URL], completionHandler:@escaping (() -> Void)) {
        
        let dispatchGroup = DispatchGroup()
        
        for url in urls {
            dispatchGroup.enter()
            let node = Node(url: url, finishConnectionHandler: { 
                dispatchGroup.leave()
            })
            nodes.append(node)
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: completionHandler)
    }
    
    
    
    public func call(method: String, params: [String: String]?, timeout: Int = 10, callbackHandler handler:([String: Any]) -> Void) {
        for node in nodes {
            if node.connected {
                let id = UUID().uuidString
                node.call(id: id, method: method, params: params, callbackHandler: { (result) in
                    print(result)
                })
            }
        }
    }
}
