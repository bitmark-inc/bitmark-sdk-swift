//
//  API.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/27/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

public protocol APIEndpoint {
    var apiServerURL: URL {get}
    var assetServerURL: URL {get}
}

extension Network: APIEndpoint {
    public var apiServerURL: URL {
        switch self.name {
        case "livenet":
            return URL(string: "https://api.bitmark.com")!
        case "testnet":
            return URL(string: "https://api.test.bitmark.com")!
        default:
            return URL(string: "https://api.devel.bitmark.com")!
        }
    }
    
    public var assetServerURL: URL {
        switch self.name {
        case "livenet":
            return URL(string: "https://assets.bitmark.com")!
        case "testnet":
            return URL(string: "https://assets.test.bitmark.com")!
        default:
            return URL(string: "https://assets.devel.bitmark.com")!
        }
    }
}

internal struct API {
    let endpoint: APIEndpoint
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    init(network: Network) {
        self.init(apiEndpoint: network)
    }
    
     init(apiEndpoint: APIEndpoint) {
        endpoint = apiEndpoint
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

internal extension URLSession {
    
    func synchronousDataTask(with request: URLRequest) throws -> (data: Data?, response: HTTPURLResponse?) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var responseData: Data?
        var theResponse: URLResponse?
        var theError: Error?
        
        
//        print("========================================================")
//        print("Request for url: \(request.url!.absoluteURL)")
//
//        if let header = request.allHTTPHeaderFields {
//            print("Request Header: \(header)")
//        }
//
//        if let body = request.httpBody {
//            print("Request Body: \(String(data: body, encoding: .ascii)!)")
//        }
        
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
        
//        if let responseD = responseData {
//            print("Resonpose Body: \(String(data: responseD, encoding: .ascii)!)")
//        }
//
//        print("========================================================")
        
        return (data: responseData, response: theResponse as! HTTPURLResponse?)
        
    }
    
}
