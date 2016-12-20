//
//  Address.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/16/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation
import BigInt
import CryptoSwift

public struct Address {
    
    public let prefix: Data
    public let pubKey: Data
    public let network: Network
    public let string: String
    public let keyType: KeyType
    
    public init(fromPubKey pubKey: Data, network: Network = Config.liveNet, keyType: KeyType = Config.ed25519) {
        self.pubKey = pubKey
        self.network = network
        
        let keyTypeVal = BigUInt(keyType.value)
        var keyVariantVal = keyTypeVal << 4
        keyVariantVal |= BigUInt(Config.KeyPart.publicKey) // first bit
        keyVariantVal |= (BigUInt(network.addressValue) << 1) // second bit indicates net
        let keyVariantData = VarInt.encode(value: keyVariantVal)
        
        let checksumData = keyVariantData.concating(data: pubKey).sha3(.sha256)
        
        let addressData = keyVariantData + pubKey + checksumData
        let base58Address = Base58.encode(addressData)
        self.string = base58Address
        self.prefix = keyVariantData
        self.keyType = keyType
    }
    
    public init(address: String) throws {
        guard let addressData = Base58.decode(address) else {
            throw("Address error: unknow address")
        }
        
        let addressBuffer = [UInt8](addressData)
        
        self.string = address
        
        let keyVariant = VarInt.decode(data: addressData)
        let keyVariantBuffer = [UInt8](keyVariant.serialize())
        
        // check for whether this is an address
        let keyPartVal = BigUInt(Config.KeyPart.publicKey)
        if (keyVariant & BigUInt(1)) ==  keyPartVal {
            throw("Address error: this is not an address")
        }
        
        // detect network
        let networkVal = (keyVariant << 1) & BigUInt(0x01)
        
        if networkVal == BigUInt(Config.liveNet.addressValue) {
            self.network = Config.liveNet
        }
        else {
            self.network = Config.testNet
        }
        
        // key type
        let keyTypeVal = (keyVariant << 4) & BigUInt(0x07)
        
        guard let keyType = Common.getKey(byValue: keyTypeVal) else {
            throw("Address error: unknow key type")
        }
        
        let addressLength = keyVariantBuffer.count + keyType.publicLength + Config.checksumLength
        
        if addressLength == addressBuffer.count{
            throw("Address error: key type " + keyType.name + " must be " +  String(addressLength) + " bytes")
        }
        
        // public key
        self.pubKey = addressData.subdata(in: keyVariantBuffer.count..<(keyVariantBuffer.count + addressLength - Config.checksumLength))
        
        // check checksum
        let checksumData = addressData.subdata(in: 0..<(keyVariantBuffer.count + keyType.publicLength))
        let checksum = checksumData.sha3(.sha256).subdata(in: 0..<Config.checksumLength)
        let checksumFromAddress = addressData.subdata(in: Config.checksumLength..<addressLength)
        
        if checksum != checksumFromAddress {
            throw("Address error: checksum mismatchs")
        }
        
        self.prefix = keyVariant.serialize()
        self.keyType = keyType
    }
    
    
}
