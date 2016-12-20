//
//  PrivateKey.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/19/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation
import BigInt
import CryptoSwift
import TweetNaclSwift_iOS

struct PrivateKey {
    
    let address: Address
    let privateKey: Data
    let type: KeyType
    let network: Network
    let kif: String
    
    init?(fromKIF kifString: String) {
        guard let kifBuffer = Base58.decode(kifString) else {
            assertionFailure("Can not convert base58")
            return nil
        }
        self.kif = kifString
        
        let keyVariant = VarInt.varintDecode(data: kifBuffer)
        let keyVariantBufferLength = keyVariant.buffer.count
        
        // check for whether this is a kif
        let keyPartVal = BigUInt(Config.KeyPart.privateKey)
        assert(keyVariant & BigUInt(1) == keyPartVal, "Private key error: can not parse the kif string")
        
        // detect network
        let networkVal = (keyVariant << 1) & BigUInt(0x01)
        guard let network = Common.getNetwork(byAddressValue: networkVal) else {
            assertionFailure("Unknow network")
            return nil
        }
        self.network = network
        
        // key type
        let keyTypeVal = (keyVariant << 4) & BigUInt(0x07)
        guard let keyType = Common.getKey(byValue: keyTypeVal) else {
            assertionFailure("Unknow key type")
            return nil
        }
        self.type = keyType
        
        // check the length of kif
        let kifLength = keyVariantBufferLength + keyType.seedLength + Config.checksumLength
        assert(kifLength == kifBuffer.count, "Private key error: KIF for"  + keyType.name + " must be " + String(kifLength) + " bytes")
        
        // get private key
        let seed = kifBuffer.slice(start: keyVariantBufferLength, length: kifLength - Config.checksumLength)
        
        // check checksum
        let checksumData = kifBuffer.subdata(in: 0..<Config.checksumLength)
        let checksum = checksumData.sha3(.sha256).slice(start: 0, length: Config.checksumLength)
        assert(checksum == kifBuffer.slice(start: kifLength - Config.checksumLength, length: kifLength), "Private key error: checksum mismatch")
        
        // get address
        guard let keyPair = Ed25519.generateKeyPair(fromSeed: seed) else {
            return nil
        }
        self.privateKey = keyPair.privateKey
        
        return nil
    }
    
    init?(fromKeyPair keyPairData: Data, network: Network, type: KeyType) {
        // Check length to determine the keypair
        
        var keyPair: (publicKey: Data, privateKey: Data)
        var seed: Data
        
        if keyPairData.count == type.privateLength {
            guard let keyPairResult = Ed25519.generateKeyPair(fromPrivateKey: keyPairData) else {
                return nil
            }
            
            keyPair = keyPairResult
            seed = Ed25519.getSeed(fromPrivateKey: keyPair.privateKey)
        }
        else if keyPairData.count == type.seedLength {
            seed = keyPairData
            
            guard let keyPairResult = Ed25519.generateKeyPair(fromSeed: seed) else {
                return nil
            }
            keyPair = keyPairResult
        }
        else {
            return nil
        }
        
        let keyPartVal = BigUInt(Config.KeyPart.privateKey)
        let networkVal = BigUInt(network.kifValue)
        let keyTypeVal = BigUInt(type.value)
        
        var keyVariantVal = (keyTypeVal << 3) | networkVal
        keyVariantVal = keyVariantVal << 1 | keyPartVal
        let keyVariantData = keyVariantVal.serialize()
        
        var checksum = keyVariantData.concating(data: seed).sha3(.sha256)
        checksum = checksum.slice(start: 0, length: Config.checksumLength)
        let kifData = keyVariantData + seed + checksum
        
        // Set data
        self.kif = Base58.encode(kifData)
        self.network = network
        self.type = type
        self.privateKey = keyPair.privateKey
        self.address = Address(fromPubKey: keyPair.publicKey, network: network, keyType: type)
    }
}
