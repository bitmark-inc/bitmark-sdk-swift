//
//  API+Transfer.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/31/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

extension API {
    internal func transfer(withData transfer: Transfer, completion:((Bool) -> Void)?) throws {
        let json = try JSONSerialization.data(withJSONObject: transfer.getRPCParam(), options: [])
        
        let requestURL = url.appendingPathComponent("/v1/transfer")
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                completion?(response.statusCode == 200)
                return
            }
            
            completion?(false)
            }.resume()
    }
}
