//
//  Connection+SupportedMethods.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/27/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

extension Connection {
    
    public func createBitmarks(params: [String: String], callbackHandler handler:([String: Any]) -> Void) {
        self.call(method: "Bitmarks.Create", params: params, callbackHandler: handler)
    }
    
    public func transferBitmarks(params: [String: String], callbackHandler handler:([String: Any]) -> Void) {
        self.call(method: "Bitmark.Transfer", params: params, callbackHandler: handler)
    }
    
    public func payByHashCash(params: [String: String], callbackHandler handler:([String: Any]) -> Void) {
        self.call(method: "Bitmarks.Proof", params: params, callbackHandler: handler)
    }
    
    public func payBitmark(params: [String: String], callbackHandler handler:([String: Any]) -> Void) {
        self.call(method: "Bitmarks.Pay", params: params, callbackHandler: handler)
    }
    
    public func nodeInfo(callbackHandler handler:([String: Any]) -> Void) {
        self.call(method: "Node.Info", params: nil, callbackHandler: handler)
    }
}
