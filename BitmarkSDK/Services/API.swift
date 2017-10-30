//
//  API.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/27/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

internal struct API {
    typealias Accessibility = String
    let url: URL
    
    init(network: Network) {
        url = URL(string: API.endPoint(forNetwork: network))!
    }
}

internal extension URLRequest {
    internal mutating func signRequest(withAccount account: Account, action: String, resource: String) throws {
        let timestamp = Common.timeStamp()
        let parts = [action, resource, account.accountNumber.string, timestamp]
        let message = parts.joined(separator: "|")
        
        let signature = try account.authKey.sign(message: message)
        
        self.addValue(account.accountNumber.string, forHTTPHeaderField: "requester")
        self.addValue(timestamp, forHTTPHeaderField: "timestamp")
        self.addValue(signature.hexEncodedString, forHTTPHeaderField: "signature")
    }
}

internal extension API {
    private static func endPoint(forNetwork network: Network) -> String {
        switch network.name {
        case "livenet":
            return "https://api.bitmark.com"
        case "testnet":
            return "https://api.test.bitmark.com"
        case "devnet":
            return "https://api.devel.bitmark.com"
        default:
            return "https://api.test.bitmark.com"
        }
    }
}
