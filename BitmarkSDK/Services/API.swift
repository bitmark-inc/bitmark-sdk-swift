//
//  API.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/27/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

internal struct API {
    let url: URL
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    init(network: Network) {
        url = URL(string: API.endPoint(forNetwork: network))!
    }
}

internal extension URLRequest {
    internal mutating func signRequest(withAccount account: Account, action: String, resource: String) throws {
        let timestamp = Common.timeStamp()
        let parts = [action, resource, account.accountNumber.string, timestamp]
        let message = parts.joined(separator: "|")
        
        let signature = try account.authKey.sign(message: message).hexEncodedString
        
        self.addValue(account.accountNumber.string, forHTTPHeaderField: "requester")
        self.addValue(timestamp, forHTTPHeaderField: "timestamp")
        self.addValue(signature, forHTTPHeaderField: "signature")
    }
}

internal extension API {
    private static func endPoint(forNetwork network: Network) -> String {
        switch network.name {
        case "livenet":
            return "https://api.bitmark.com"
        case "testnet":
            // TODO: should be testnet, just for the time developing the SDK
            return "https://api.devel.bitmark.com"
        default:
            return "https://api.test.bitmark.com"
        }
    }
}
