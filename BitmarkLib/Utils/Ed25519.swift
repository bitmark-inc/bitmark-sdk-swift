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
    
    static func generateKeyPair() -> (publicKey: Data, privateKey: Data)? {
        do {
            let keyPair = try NaclSign.KeyPair.keyPair()
            return (keyPair.publicKey as Data, keyPair.secretKey as Data)
        }
        catch {
            print("generateKeyPair failed")
        }
        
        return nil
    }
    
    static func generateKeyPair(fromSeed seed: Data) -> (publicKey: Data, privateKey: Data)? {
        do {
            let keyPair = try NaclSign.KeyPair.keyPair(fromSeed: seed.nsdata)
            return (keyPair.publicKey as Data, keyPair.secretKey as Data)
        }
        catch {
            print("generateKeyPair failed")
        }
        
        return nil
    }
    
    static func getSeed(fromPrivateKey privateKey: Data) -> Data {
        return privateKey.slice(start: 0, length: Config.ed25519.seedLength)
    }
    
    static func generateKeyPair(fromPrivateKey privateKey: Data) -> (publicKey: Data, privateKey: Data)? {
        do {
            let keyPair = try NaclSign.KeyPair.keyPair(fromSecretKey: privateKey.nsdata)
            return (keyPair.publicKey as Data, keyPair.secretKey as Data)
        }
        catch {
            print("generateKeyPair failed")
        }
        
        return nil
    }
    
    static func getSignature(message: Data, privateKey: Data) -> Data? {
        do {
            let signature = try NaclSign.signDetached(message: message.nsdata, secretKey: privateKey.nsdata)
            return signature as Data
        }
        catch {
            print("getSignature failed")
        }
        return nil
    }
}
