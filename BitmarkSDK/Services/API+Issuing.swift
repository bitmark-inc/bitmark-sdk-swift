//
//  API+Issuing.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/30/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

extension API {
    public func issue(withIssues issues: [Issue], assets: [Asset], completion:((Bool) -> Void)?) throws {
        let issuePayloads = try issues.map {try $0.getRPCParam()}
        let assetPayloads = try assets.map {try $0.getRPCParam()}
        
        let payload = ["issues": issuePayloads,
                       "assets": assetPayloads]
        
        let json = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        print(String(data: json, encoding: .utf8)!)
        
        let requestURL = url.appendingPathComponent("/v1/issue")
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            print(String(data: data!, encoding: .utf8)!)
            if let response = response as? HTTPURLResponse {
                completion?(response.statusCode == 200)
                return
            }
            completion?(false)
            }.resume()
    }
}
