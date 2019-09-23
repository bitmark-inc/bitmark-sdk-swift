//
//  API.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/27/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

struct APIEndpoint {
    public let network: Network
    private(set) var apiServerURL: URL
    
    public mutating func setEndpoint(api: URL, asset: URL) {
        self.apiServerURL = api
    }
}

extension APIEndpoint {
    public static let livenetEndpoint = APIEndpoint(network: .livenet,
                                                    apiServerURL: URL(string: "https://api.bitmark.com")!)
    
    public static let testnetEndpoint = APIEndpoint(network: .testnet,
                                                    apiServerURL: URL(string: "https://api.test.bitmark.com")!)
    
    internal static func endPointForNetwork(_ network: Network) -> APIEndpoint {
        switch network {
        case .livenet:
            return livenetEndpoint
        case .testnet:
            return testnetEndpoint
        }
    }
}

internal struct API {
    let endpoint: APIEndpoint
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    init() {
        self.init(apiEndpoint: APIEndpoint.endPointForNetwork(globalConfig.network))
    }
    
    init(network: Network) {
        self.init(apiEndpoint: APIEndpoint.endPointForNetwork(network))
    }
    
    init(apiEndpoint: APIEndpoint) {
        endpoint = apiEndpoint
    }
}

internal extension API {
    func asynchronousRequest(method: String, urlPath: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = endpoint.apiServerURL.appendingPathComponent(urlPath)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlSession.dataTask(with: url, completionHandler: completionHandler)
    }
}

internal extension URLRequest {
    mutating func signRequest(withAccount account: KeypairSignable, action: String, resource: String) throws {
        let timestamp = Common.timestamp()
        let parts = [action, resource, account.address, timestamp]
        try signRequest(withAccount: account, parts: parts, timestamp: timestamp)
    }
    
    mutating func signRequest(withAccount account: KeypairSignable, parts: [String], timestamp: String) throws {
        let messageString = parts.joined(separator: "|")
        let messageData = messageString.data(using: .utf8)!
        
        let signature = try account.sign(message: messageData).hexEncodedString
        
        self.addValue(account.address, forHTTPHeaderField: "requester")
        self.addValue(timestamp, forHTTPHeaderField: "timestamp")
        self.addValue(signature, forHTTPHeaderField: "signature")
    }
}

internal extension URLSession {
    
    func synchronousDataTask(with request: URLRequest) throws -> (data: Data, response: HTTPURLResponse) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var responseData: Data?
        var theResponse: URLResponse?
        var theError: Error?
        
        // Add api token
        var modifyRequest = request
        modifyRequest.setValue("Bearer " + globalConfig.apiToken, forHTTPHeaderField: "Authorization")
        modifyRequest.setValue("*", forHTTPHeaderField: "Accept-Encoding")
        modifyRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        modifyRequest.setValue(String(format: "%@, %@ %@", "bitmark-sdk-swift", UIDevice.current.systemName, UIDevice.current.systemVersion), forHTTPHeaderField: "User-Agent")
        
        dataTask(with: modifyRequest) { (data, response, error) -> Void in
            responseData = data
            theResponse = response
            theError = error
            
            semaphore.signal()
            
            }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let error = theError {
            throw error
        }
        
        guard let data = responseData,
            let response = theResponse as? HTTPURLResponse else {
                throw("Empty response from request: " + request.description)
        }
        
        globalConfig.logger.log(level: .info,
                                message: "Request: \(modifyRequest.httpMethod ?? "GET") \(request.url!.absoluteURL)",
                                userInfo: ["module": "BitmarkSDK_APIRequest",
                                           "URLRequest": modifyRequest,
                                           "URLResponse": response])
        
        if 200..<300 ~= response.statusCode || response.statusCode == 404 {
            return (data: data, response: response)
        } else {
            let requestMethod = request.httpMethod ?? "GET"
            let responseMessage = String(data: data, encoding: .utf8) ?? ""
            throw("Request " + requestMethod + " " + request.url!.absoluteString + " returned with statuscode: " + String(response.statusCode) + " and data: " + responseMessage)
        }
    }
    
}
