//
//  Gateway.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/10/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

public struct Gateway {
    
    public static func doIssue(withData issue: Issue, network: Network = Network.livenet, responseHandler:((String?, Error?) -> Void)?) throws {
        let json = try JSONSerialization.data(withJSONObject: issue.getRPCParam(), options: [])
        
        var endpointURL = URL(string: endPoint(forNetwork: network))!
        endpointURL.appendPathComponent("/v1/issue")
        
        var urlRequest = URLRequest(url: endpointURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let result = String(data: data!, encoding: .utf8)
            responseHandler?(result, error)
        }.resume()
    }
    
    public static func doTransfer(withData transfer: Transfer, network: Network = Network.livenet, responseHandler:((String?, Error?) -> Void)?) throws {
        let json = try JSONSerialization.data(withJSONObject: transfer.getRPCParam(), options: [])
        print(String(data: json, encoding: .utf8)!)
        var endpointURL = URL(string: endPoint(forNetwork: network))!
        endpointURL.appendPathComponent("/v1/transfer")
        
        var urlRequest = URLRequest(url: endpointURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let result = String(data: data!, encoding: .utf8)
            responseHandler?(result, error)
            }.resume()
    }
}

extension Gateway {
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
