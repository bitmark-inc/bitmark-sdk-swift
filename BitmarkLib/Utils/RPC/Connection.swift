//
//  Connection.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/26/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import CocoaAsyncSocket

public class Connection: NSObject {
    
    public static let shared = Connection()
    var sockets = [GCDAsyncSocket]()
    
    
    public func startConnection(from urls: [URL]) {
        for url in urls {
            let host = url.host!
            let port = url.port!
            
            let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
            
            do {
                
                try socket.connect(toHost: url.host!, onPort: UInt16(url.port!))
                sockets.append(socket)
            }
            catch let e {
                print(e)
            }
        }
    }
    
    
    
    public func call(method: String, params: [String: String]?, timeout: Int = 10) {
        var dataDic = [String: Any]()
        dataDic["id"] = 1
        dataDic["method"] = method
        dataDic["params"] = params != nil ? [params!] : []
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dataDic, options: .prettyPrinted)
            for socket in sockets {
                socket.write(data, withTimeout:-1, tag: 0)
                
                socket.readData(withTimeout: -1, tag: 0)
            }
        }
        catch {
            print("Convert to json data failed")
        }
    }
}

extension Connection: GCDAsyncSocketDelegate {
    public func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        print("Socket did connect to url")
    }
    
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if let string = String(data: data, encoding: .utf8) {
            
            print("Received data: " + string)
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
}
