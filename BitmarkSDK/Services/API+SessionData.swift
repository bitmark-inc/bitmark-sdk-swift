//
//  API+SessionData.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 11/2/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

internal extension API {
    
    internal func registerEncryptionPublicKey(forAccount account: Account, completion: ((Bool) -> Void)?) throws {
        let signature = try account.authKey.sign(message: account.encryptionKey.publicKey).hexEncodedString
        let params = ["encryption_pubkey": account.encryptionKey.publicKey.hexEncodedString,
                      "signature": signature]
        
        let requestURL = url.appendingPathComponent("/v1/encryption_keys/" + account.accountNumber.string)
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        
        let data = try JSONSerialization.data(withJSONObject: params, options: [])
        print(String(data: data, encoding: .utf8)!)
        urlSession.dataTask(with: urlRequest) { (result, response, error) in
            print(String(data: result!, encoding: .utf8)!)
            completion?(error != nil)
        }.resume()
    }
    
    internal func updateSession(account: Account, bitmarkId: String, recipient: String, data: Data, completion: ((Bool) -> Void)?) throws {
        let requestURL = url.appendingPathComponent("/v2/session")
        
        let params = ["bitmark_id": bitmarkId,
                       "owner": recipient,
                       "session_data": data.hexEncodedString]
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        try urlRequest.signRequest(withAccount: account, action: "updateSession", resource: data.hexEncodedString)
        
        urlSession.dataTask(with: urlRequest) { (result, response, error) in
            print(String(data: result!, encoding: .utf8)!)
            completion?(error != nil)
        }.resume()
    }
    
    
}
