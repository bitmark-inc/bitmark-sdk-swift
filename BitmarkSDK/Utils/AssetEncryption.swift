//
//  AssetEncryption.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 11/2/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation
import CryptoSwift

struct SessionData {
    let encryptedDataKey: Data
    let encryptedDataKeySignature: Data
    let dataKeySignature: Data
    let dataKeyAlgorithm: String
}

extension SessionData {
    func serialize() throws -> Data {
        let dic = [["enc_data_key": encryptedDataKey.hexEncodedString],
                   ["enc_data_key_sig": encryptedDataKeySignature.hexEncodedString],
                   ["data_key_sig": dataKeySignature.hexEncodedString],
                   ["data_key_alg": dataKeyAlgorithm]]
        
        return try JSONSerialization.data(withJSONObject: dic, options: [])
    }
}

struct AssetEncryption {
    
    let key = Common.randomBytes(length: 32)
    private let cipher: ChaCha20
    private let iv = Array<UInt8>(repeating: 0, count: 12)
    
    init() throws {
        cipher = try ChaCha20(key: key.bytes, iv: iv)
    }
    
    func encrypt(data: Data, signWithAccount account: Account) throws -> (encryptedData: Data, sessionData: SessionData) {
        let encryptedData = try data.encrypt(cipher: cipher)
        
        return (encryptedData,
                try createSessionData(account: account,
                                      sessionKey: key,
                                      forRecipient: account.encryptionKey.publicKey))
    }
    
    func decypt(data: Data) throws -> Data {
        return try data.decrypt(cipher: cipher)
    }
}

extension AssetEncryption {
    
    func createSessionData(account: Account, sessionKey: Data, forRecipient publicKey: Data) throws -> SessionData {
        let encryptedSessionKey = try account.encryptionKey.publicKeyEncrypt(message: sessionKey,
                                                                         withRecipient: publicKey,
                                                                         signWith: account.encryptionKey.privateKey)
        
        return SessionData(encryptedDataKey: encryptedSessionKey,
                           encryptedDataKeySignature: try account.authKey.sign(message: encryptedSessionKey),
                           dataKeySignature: try account.authKey.sign(message: sessionKey),
                           dataKeyAlgorithm: "chacha20poly1305")
    }
    
    
}
