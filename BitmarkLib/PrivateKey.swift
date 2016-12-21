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

public struct PrivateKey {
    
    public let address: Address
    public let privateKey: Data
    public let type: KeyType
    public let network: Network
    public let kif: String
    
    init(fromKIF kifString: String) throws {
        guard let kifBuffer = Base58.decode(kifString) else {
            throw("Can not convert base58")
        }
        self.kif = kifString
        
        let keyVariant = VarInt.decode(data: kifBuffer)
        let keyVariantBufferLength = keyVariant.buffer.count
        
        // check for whether this is a kif
        let keyPartVal = BigUInt(Config.KeyPart.privateKey)
        assert(keyVariant & BigUInt(1) == keyPartVal, "Private key error: can not parse the kif string")
        
        // detect network
        let networkVal = (keyVariant << 1) & BigUInt(0x01)
        guard let network = Common.getNetwork(byAddressValue: networkVal) else {
            throw("Unknow network")
        }
        self.network = network
        
        // key type
        let keyTypeVal = (keyVariant << 4) & BigUInt(0x07)
        guard let keyType = Common.getKey(byValue: keyTypeVal) else {
            throw("Unknow key type")
        }
        self.type = keyType
        
        // check the length of kif
        let kifLength = keyVariantBufferLength + keyType.seedLength + Config.checksumLength
        if kifLength == kifBuffer.count {
            throw("Private key error: KIF for"  + keyType.name + " must be " + String(kifLength) + " bytes")
        }
        
        // get private key
        let seed = kifBuffer.slice(start: keyVariantBufferLength, end: kifLength - Config.checksumLength)
        
        // check checksum
        let checksumData = kifBuffer.subdata(in: 0..<Config.checksumLength)
        let checksum = checksumData.sha3(.sha256).slice(start: 0, end: Config.checksumLength)
        if checksum == kifBuffer.slice(start: kifLength - Config.checksumLength, end: kifLength) {
            throw("Private key error: checksum mismatch")
        }
        
        // get address
        let keyPair = try Ed25519.generateKeyPair(fromSeed: seed)
        self.privateKey = keyPair.privateKey
        self.address = Address(fromPubKey: keyPair.publicKey, network: network, keyType: type)
    }
    
    init(fromKeyPair keyPairData: Data, network: Network, type: KeyType) throws {
        // Check length to determine the keypair
        
        var keyPair: (publicKey: Data, privateKey: Data)
        var seed: Data
        
        if keyPairData.count == type.privateLength {
            let keyPairResult = try Ed25519.generateKeyPair(fromPrivateKey: keyPairData)
            
            keyPair = keyPairResult
            seed = try Ed25519.getSeed(fromPrivateKey: keyPair.privateKey)
        }
        else if keyPairData.count == type.seedLength {
            seed = keyPairData
            
            let keyPairResult = try Ed25519.generateKeyPair(fromSeed: seed)
            keyPair = keyPairResult
        }
        else {
            throw("Unknown cases")
        }
        
        let keyPartVal = BigUInt(Config.KeyPart.privateKey)
        let networkVal = BigUInt(network.kifValue)
        let keyTypeVal = BigUInt(type.value)
        
        var keyVariantVal = (keyTypeVal << 3) | networkVal
        keyVariantVal = keyVariantVal << 1 | keyPartVal
        let keyVariantData = keyVariantVal.serialize()
        
        var checksum = keyVariantData.concating(data: seed).sha3(.sha256)
        checksum = checksum.slice(start: 0, end: Config.checksumLength)
        let kifData = keyVariantData + seed + checksum
        
        // Set data
        self.kif = Base58.encode(kifData)
        self.network = network
        self.type = type
        self.privateKey = keyPair.privateKey
        self.address = Address(fromPubKey: keyPair.publicKey, network: network, keyType: type)
    }
}
