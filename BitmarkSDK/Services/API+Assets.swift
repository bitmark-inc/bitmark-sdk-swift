//
//  API+Assets.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/30/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

internal extension API {
    internal func uploadAsset(data: Data, fileName: String, assetId: String, accessibility: Accessibility, fromAccount account: Account, completion: ((Bool) -> Void)?) throws {
        let params = ["asset_id": assetId,
                      "accessibility": accessibility.rawValue]
        
        let requestURL = url.appendingPathComponent("/v1/assets")
        
        var request = API.multipartRequest(data: data, fileName: fileName, toURL: requestURL, otherParams: params)
        try request.signRequest(withAccount: account, action: "uploadAsset", resource: assetId)
        
        URLSession.shared.dataTask(with: request) { (result, response, error) in
            if let response = response as? HTTPURLResponse {
                completion?(response.statusCode == 200)
                return
            }
            
            completion?(false)
            }.resume()
    }
    
    private static func multipartRequest(data: Data, fileName: String, toURL url: URL, otherParams: [String: String]?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: otherParams, boundary: boundary, data: data, mimeType: "", filename: fileName)
        
        return request
    }
    
    private static func createBody(parameters: [String: String]?,
                                   boundary: String,
                                   data: Data,
                                   mimeType: String,
                                   filename: String) -> Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append(string: boundaryPrefix)
                body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append(string: "\(value)\r\n")
            }
        }
        
        body.append(string: boundaryPrefix)
        body.append(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.append(string: "Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append(string: "\r\n")
        body.append(string: "--".appending(boundary.appending("--")))
        
        return body
    }
}

fileprivate extension Data {
    fileprivate mutating func append(string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
