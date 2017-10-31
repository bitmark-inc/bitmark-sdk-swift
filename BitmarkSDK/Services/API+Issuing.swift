//
//  API+Issuing.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/30/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

extension API {
    internal func issue(withIssues issues: [Issue], assets: [Asset], completion:((Bool, [String?]?) -> Void)?) throws {
        let issuePayloads = try issues.map {try $0.getRPCParam()}
        let assetPayloads = try assets.map {try $0.getRPCParam()}
        
        let payload = ["issues": issuePayloads,
                       "assets": assetPayloads]
        
        let json = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        let requestURL = url.appendingPathComponent("/v1/issue")
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let r = response as? HTTPURLResponse,
                let d = data else {
                    completion?(false, nil)
                    return
            }
            
            do {
                let result = try JSONDecoder().decode([[String: String]].self, from: d)
                let bitmarkIDs = result.map {$0["txId"]}
                completion?(r.statusCode == 200, bitmarkIDs)
            }
            catch let e {
                print(e)
                completion?(false, nil)
            }
            }.resume()
    }
}
