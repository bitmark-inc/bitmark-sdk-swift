//
//  Keypair.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 11/2/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation
import TweetNacl

// Just for the information?
enum Algorithm {
    case ed25519
    case curve25519
}

protocol AsymmetricKey {
    var privateKey: Data {get}
    var publicKey: Data {get}
    var algorithm: Algorithm {get}
}

struct EncryptionKey: AsymmetricKey {
    let privateKey: Data
    let publicKey: Data
    let algorithm = Algorithm.curve25519
}

extension EncryptionKey {
    func publicKeyEncrypt(message: Data, withRecipient publicKey: Data, signWith privateKey: Data) throws -> Data {
        let nonce = Common.randomBytes(length: 24)
        
        let key = try TweetNacl.NaclBox.before(publicKey: publicKey, secretKey: privateKey)
        return try TweetNacl.NaclSecretBox.secretBox(message: message, nonce: nonce, key: key)
    }
}
