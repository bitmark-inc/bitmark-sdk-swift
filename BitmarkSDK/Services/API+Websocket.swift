//
//  API+Websocket.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 6/7/19.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import SwiftCentrifuge

extension API {
    struct WSTokenResponse: Codable {
        let token: String
    }
    
    internal func requestWSToken(signable: KeypairSignable) throws -> String {
        let timestamp = Common.timestamp()
        
        let parts = ["register",
                     "websocket",
                     signable.address,
                     timestamp]
        let message = parts.joined(separator: "|")
        let signature = try signable.sign(message: message.data(using: .utf8)!)
        
        let requestURL = endpoint.apiServerURL.appendingPathComponent("/v3/ws-auth")
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(String(signable.address), forHTTPHeaderField: "requester")
        urlRequest.setValue(timestamp, forHTTPHeaderField: "timestamp")
        urlRequest.setValue(signature.hexEncodedString, forHTTPHeaderField: "signature")
        
        let (data, _) = try urlSession.synchronousDataTask(with: urlRequest)
        
        let decoder = JSONDecoder()
        let wsAuthResponse = try decoder.decode(WSTokenResponse.self, from: data)
        return wsAuthResponse.token
    }
}
