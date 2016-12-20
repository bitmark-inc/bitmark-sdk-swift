//
//  Ed25519.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/20/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation
import TweetNaclSwift_iOS

class Ed25519 {
    
    static func generateKeyPair() throws -> (publicKey: Data, privateKey: Data) {
        let keyPair = try NaclSign.KeyPair.keyPair()
        return (keyPair.publicKey as Data, keyPair.secretKey as Data)
    }
    
    static func generateKeyPair(fromSeed seed: Data) throws -> (publicKey: Data, privateKey: Data) {
        let keyPair = try NaclSign.KeyPair.keyPair(fromSeed: seed.nsdata)
        return (keyPair.publicKey as Data, keyPair.secretKey as Data)
    }
    
    static func getSeed(fromPrivateKey privateKey: Data) throws -> Data {
        return privateKey.slice(start: 0, length: Config.ed25519.seedLength)
    }
    
    static func generateKeyPair(fromPrivateKey privateKey: Data) throws -> (publicKey: Data, privateKey: Data) {
        let keyPair = try NaclSign.KeyPair.keyPair(fromSecretKey: privateKey.nsdata)
        return (keyPair.publicKey as Data, keyPair.secretKey as Data)
    }
    
    static func getSignature(message: Data, privateKey: Data) throws -> Data {
        let signature = try NaclSign.signDetached(message: message.nsdata, secretKey: privateKey.nsdata)
        return signature as Data
    }
}
