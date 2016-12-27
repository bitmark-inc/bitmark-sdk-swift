//
//  Connection+SupportedMethods.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/27/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

extension Connection {
    
    public func createBitmarks(params: [String: String]) {
        self.call(method: "Bitmarks.Create", params: params)
    }
    
    public func transferBitmarks(params: [String: String]) {
        self.call(method: "Bitmark.Transfer", params: params)
    }
    
    public func payByHashCash(params: [String: String]) {
        self.call(method: "Bitmarks.Proof", params: params)
    }
    
    public func payBitmark(params: [String: String]) {
        self.call(method: "Bitmarks.Pay", params: params)
    }
    
    public func nodeInfo() {
        self.call(method: "Node.Info", params: nil)
    }
}
