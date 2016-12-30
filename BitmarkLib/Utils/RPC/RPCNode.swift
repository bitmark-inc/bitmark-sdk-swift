//
//  Node.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/29/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import CocoaAsyncSocket

public struct NodeResult {
    let result: [String: Any]?
    let error: String?
}

public class Node: NSObject {
    fileprivate var callbackDic = [String: (NodeResult) -> Void]()
    internal var url: URL
    fileprivate var socket: GCDAsyncSocket?
    private let queue = DispatchQueue(label: "com.bitmark.nodeconnection", qos: .background)
    
    var connected = false
    var finishConnectionHandler: ((Bool) -> Void)?
    
    let aliveExpireCheck = Date(timeIntervalSinceNow: TimeInterval(Config.RPCConfig.aliveNodeExpiry))
    
    init(url: URL, finishConnectionHandler handler: @escaping (Bool) -> Void) {
        
        self.url = url
        
        super.init()
        
        connect(handler)
    }
    
    public func connect(_ handler: @escaping (Bool) -> Void) {
        
        finishConnectionHandler = handler
        socket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
        
        do {
            try socket?.connect(toHost: url.host!, onPort: UInt16(url.port!))
        }
        catch let e {
            print(e)
        }
    }
    
    public func disconnect() {
        socket?.disconnect()
    }
    
    public func call(id: String,
                     method: String,
                     params: [String: Any]?,
                     timeout: Int = 10,
                     callbackHandler handler:@escaping (NodeResult) -> Void) {
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
                self.socket?.readData(withTimeout: TimeInterval(timeout), tag: 0)
            }
            catch {
                print("Convert to json data failed")
            }
        }
    }
    
    // Query info from node to ensure node is alive
    public func getInfo(_ handler: ((Bool) -> Void)?) {
        call(id: UUID().uuidString, method: "Node.Info", params: nil, timeout: 10) { (nodeResult) in
            handler?(nodeResult.result != nil && nodeResult.error == nil)
        }
    }
}

extension Node: GCDAsyncSocketDelegate {
    
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                if let id = jsonResult["id"] as? String {
                    
                    let result = jsonResult["result"] as? [String: Any]
                    let error = jsonResult["error"] as? String
                    
                    // Trigger the callback
                    callbackDic[id]?(NodeResult(result: result, error: error))
                }
                else {
                    print("Cannot get id and result from received json")
                    if let errorMessage = jsonResult["error"] as? String {
                        print(errorMessage)
                    }
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
        
        // When entered to TLS mode, try to get node info to ensure node is alive
        getInfo { [unowned self] (success) in
            self.connected = success
            self.finishConnectionHandler?(success)
        }
    }
    
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("Socket didconnected: " + url.absoluteString)
        finishConnectionHandler?(false)
    }
}
