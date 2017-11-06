//
//  API+SessionData.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 11/2/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

struct SessionData {
    let encryptedDataKey: Data
    let encryptedDataKeySignature: Data
    let dataKeySignature: Data
    let dataKeyAlgorithm: String
}

extension SessionData: Codable {
    
    enum SessionDataKeys: String, CodingKey {
        case encryptedDataKey = "enc_data_key"
        case encryptedDataKeySignature = "enc_data_key_sig"
        case dataKeySignature = "data_key_sig"
        case dataKeyAlgorithm = "data_key_alg"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SessionDataKeys.self)
        self.init(encryptedDataKey: try container.decode(String.self, forKey: SessionDataKeys.encryptedDataKey).hexDecodedData,
                  encryptedDataKeySignature: try container.decode(String.self, forKey: SessionDataKeys.encryptedDataKeySignature).hexDecodedData,
                  dataKeySignature: try container.decode(String.self, forKey: SessionDataKeys.dataKeySignature).hexDecodedData,
                  dataKeyAlgorithm: "chacha20poly1305")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SessionDataKeys.self)
        try container.encode(self.encryptedDataKey.hexEncodedString, forKey: .encryptedDataKey)
        try container.encode(self.encryptedDataKeySignature.hexEncodedString, forKey: .encryptedDataKeySignature)
        try container.encode(self.dataKeySignature.hexEncodedString, forKey: .dataKeySignature)
    }
}

extension SessionData {
    func serialize() -> [String: String] {
        return ["enc_data_key": encryptedDataKey.hexEncodedString,
                "enc_data_key_sig": encryptedDataKeySignature.hexEncodedString,
                "data_key_sig": dataKeySignature.hexEncodedString]
    }
}

struct AssetAccess {
    let url: String
    let sender: String
    let sessionData: SessionData?
}

extension AssetAccess: Codable {
    
    enum AssetAccessKeys: String, CodingKey {
        case url = "url"
        case sender = "sender"
        case sessionData = "session_data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AssetAccessKeys.self)
        self.init(url: try container.decode(String.self, forKey: AssetAccessKeys.url),
                  sender: try container.decode(String.self, forKey: AssetAccessKeys.sender),
                  sessionData: try container.decode(SessionData?.self, forKey: AssetAccessKeys.sessionData))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AssetAccessKeys.self)
        try container.encode(self.url, forKey: .url)
        try container.encode(self.sender, forKey: .sender)
        try container.encode(self.sessionData, forKey: .sessionData)
    }
}

internal extension API {
    
    func registerEncryptionPublicKey(forAccount account: Account, completion: ((Bool) -> Void)?) throws {
        let signature = try account.authKey.sign(message: account.encryptionKey.publicKey).hexEncodedString
        let params = ["encryption_pubkey": account.encryptionKey.publicKey.hexEncodedString,
                      "signature": signature]
        
        let requestURL = apiServerURL.appendingPathComponent("/v1/encryption_keys/" + account.accountNumber.string)
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        
        let data = try JSONSerialization.data(withJSONObject: params, options: [])
        print(String(data: data, encoding: .utf8)!)
        urlSession.dataTask(with: urlRequest) { (result, response, error) in
            print(String(data: result!, encoding: .utf8)!)
            completion?(error != nil)
        }.resume()
    }
    
    func getEncryptionPublicKey(accountNumber: String) throws -> String? {
        let urlString = "https://key.\(assetServerURL.host!)/\(accountNumber)"
        let requestURL = URL(string: urlString)!
        let urlRequest = URLRequest(url: requestURL)
        
        let (r, _) = try urlSession.synchronousDataTask(with: urlRequest)
        guard let result = r else {
            return nil
        }
        
        let dic = try? JSONDecoder().decode([String: String].self, from: result)
        return dic?["encryption_pubkey"]
    }
    
    func updateSession(account: Account, bitmarkId: String, recipient: String, sessionData: SessionData) throws -> Bool {
        let requestURL = apiServerURL.appendingPathComponent("/v2/session")
        
        let params: [String: Any] = ["bitmark_id": bitmarkId,
                                     "owner": recipient,
                                     "session_data": sessionData.serialize()]
        
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        let sessionDataSerialized = try JSONEncoder().encode(sessionData)
        try urlRequest.signRequest(withAccount: account, action: "updateSession", resource: String(data: sessionDataSerialized, encoding: .ascii)!)
        
        let (r, res) = try urlSession.synchronousDataTask(with: urlRequest)
        guard let result = r,
            let response = res else {
            return false
        }
        
        print(String(data: result, encoding: .ascii)!)
        
        return response.statusCode < 300
    }
    
    func getAssetAccess(account: Account, bitmarkId: String) throws -> AssetAccess? {
        let requestURL = apiServerURL.appendingPathComponent("/v1/bitmarks/" + bitmarkId + "/asset")
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "GET"
        try urlRequest.signRequest(withAccount: account, action: "downloadAsset", resource: bitmarkId)
        
        let (r, res) = try urlSession.synchronousDataTask(with: urlRequest)
        guard let result = r,
            let response = res,
            response.statusCode < 300 else {
            return nil
        }
        
        print(String(data: result, encoding: .ascii)!)
        
        return try JSONDecoder().decode(AssetAccess.self, from: result)
    }
}

extension SessionData {
    
    static func createSessionData(account: Account, sessionKey: Data, forRecipient publicKey: Data) throws -> SessionData {
        let encryptedSessionKey = try account.encryptionKey.publicKeyEncrypt(message: sessionKey,
                                                                             withRecipient: publicKey)
        
        return SessionData(encryptedDataKey: encryptedSessionKey,
                           encryptedDataKeySignature: try account.authKey.sign(message: encryptedSessionKey),
                           dataKeySignature: try account.authKey.sign(message: sessionKey),
                           dataKeyAlgorithm: "chacha20poly1305")
    }
    
    
}
