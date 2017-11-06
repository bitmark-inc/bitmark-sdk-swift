//
//  API.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/27/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

internal struct API {
    let apiServerURL: URL
    let assetServerURL: URL
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    init(network: Network) {
        switch network.name {
        case "livenet":
            apiServerURL = URL(string: "https://api.bitmark.com")!
            assetServerURL = URL(string: "https://assets.bitmark.com")!
        case "testnet":
            // TODO: should be testnet, just for the time developing the SDK
            apiServerURL = URL(string: "https://api.devel.bitmark.com")!
            assetServerURL = URL(string: "https://assets.devel.bitmark.com")!
        default:
            apiServerURL = URL(string: "https://api.devel.bitmark.com")!
            assetServerURL = URL(string: "https://assets.devel.bitmark.com")!
        }
        
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

internal extension URLSession {
    
    func synchronousDataTask(with request: URLRequest) throws -> (data: Data?, response: HTTPURLResponse?) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var responseData: Data?
        var theResponse: URLResponse?
        var theError: Error?
        
        dataTask(with: request) { (data, response, error) -> Void in
            
            responseData = data
            theResponse = response
            theError = error
            
            semaphore.signal()
            
            }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let error = theError {
            throw error
        }
        
        return (data: responseData, response: theResponse as! HTTPURLResponse?)
        
    }
    
}
