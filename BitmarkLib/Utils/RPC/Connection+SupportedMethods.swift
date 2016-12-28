//
//  Connection+SupportedMethods.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/27/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

extension Connection {
    
    public func createBitmarks(params: [String: String], callbackHandler handler:@escaping (NodeResult) -> Void) {
        self.call(method: "Bitmarks.Create", params: params) { (results) in
            print(results)
            handler(results[0])
        }
    }
    
    public func transferBitmarks(params: [String: String], callbackHandler handler:@escaping (NodeResult) -> Void) {
        self.call(method: "Bitmark.Transfer", params: params) { (results) in
            print(results)
            handler(results[0])
        }
    }
    
    public func payByHashCash(params: [String: String], callbackHandler handler:@escaping (NodeResult) -> Void) {
        self.call(method: "Bitmarks.Proof", params: params) { (results) in
            print(results)
            handler(results[0])
        }
    }
    
    public func payBitmark(params: [String: String], callbackHandler handler:@escaping (NodeResult) -> Void) {
        self.call(method: "Bitmarks.Pay", params: params) { (results) in
            print(results)
            handler(results[0])
        }
    }
    
    public func nodeInfo(callbackHandler handler:@escaping (NodeResult) -> Void) {
        self.call(method: "Node.Info", params: nil) { (results) in
            handler(results[0])
        }
    }
}
