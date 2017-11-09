//
//  AssetEncryption.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 11/2/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation
import CryptoSwift
import TweetNacl

struct AssetEncryption {

    let key: Data
    private let cipher: ChaCha20
    private let iv = Array<UInt8>(repeating: 0, count: 12)
    
    init() throws {
        let key = Common.randomBytes(length: 32)
        try self.init(key: key)
    }
    
    init(key: Data) throws {
        if key.count != 32 {
            throw(BMError("Invalid key length for chacha20, actual count: \(key.count)"))
        }
        self.key = key
        cipher = try ChaCha20(key: key.bytes, iv: iv)
    }
    
    func encrypt(data: Data, signWithAccount account: Account) throws -> (encryptedData: Data, sessionData: SessionData) {
        let encryptedData = try data.encrypt(cipher: cipher)
        
        return (encryptedData,
                try SessionData.createSessionData(account: account,
                                      sessionKey: key,
                                      forRecipient: account.encryptionKey.publicKey))
    }
    
    func decypt(data: Data) throws -> Data {
        return try data.decrypt(cipher: cipher)
    }
}

extension AssetEncryption {
    static func encryptionKey(fromSessionData sessionData: SessionData, account: Account, senderEncryptionPublicKey: Data, senderAuthPublicKey: Data) throws -> AssetEncryption {
        // Decrypt message
        let key = try account.encryptionKey.decrypt(encryptedMessage: sessionData.encryptedDataKey, peerPublicKey: senderEncryptionPublicKey)
        
        print(key.hexEncodedString)
        print(senderAuthPublicKey.hexEncodedString)
//        
//        // Verify signature
//        let test = try TweetNacl.NaclSign.signDetachedVerify(message: sessionData.encryptedDataKey, sig: sessionData.encryptedDataKeySignature, publicKey: senderAuthPublicKey)
//        if !test {
//            throw(BMError("Signature verification failed"))
//        }
        
        return try AssetEncryption(key: key)
    }
}
