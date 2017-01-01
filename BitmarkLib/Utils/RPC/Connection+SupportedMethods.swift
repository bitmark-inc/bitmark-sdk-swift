//
//  Connection+SupportedMethods.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/27/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

extension Connection {
    
    public func createBitmarks(assets: [Asset], issues: [Issue], callbackHandler handler:@escaping (NodeResult) -> Void) {
        let rpcParams = ["assets": PoolHelper.convertRPCParams(from: assets),
                         "issues": PoolHelper.convertRPCParams(from: issues)]
        
        self.call(method: "Bitmarks.Create", params: rpcParams) { (results) in
            
            let result = Common.getMostAppearedValue(nodeResults: results, keys: ["payId", "payNonce", "difficulty"])
            handler(result)
        }
    }
    
    public func transferBitmarks(params: [String: String], callbackHandler handler:@escaping (NodeResult) -> Void) {
        self.call(method: "Bitmark.Transfer", params: params) { (results) in
            let result = Common.getMostAppearedValue(nodeResults: results, keys: ["payId", "payments"])
            handler(result)
        }
    }
    
    public func payByHashCash(params: [String: String], callbackHandler handler:@escaping (NodeResult) -> Void) {
        self.call(method: "Bitmarks.Proof", params: params) { (results) in
            let result = Common.getMostAppearedValue(nodeResults: results, keys: nil)
            handler(result)
        }
    }
    
    public func payBitmark(params: [String: String], callbackHandler handler:@escaping (NodeResult) -> Void) {
        self.call(method: "Bitmarks.Pay", params: params) { (results) in
            let result = Common.getMostAppearedValue(nodeResults: results, keys: nil)
            handler(result)
        }
    }
}
