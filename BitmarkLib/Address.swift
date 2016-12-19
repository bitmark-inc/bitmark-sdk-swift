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

struct Address {
    
    let prefix: Data
    let pubKey: Data
    let network: Config.Network
    let string: String
    let keyType: Config.KeyType
    
    init(fromEd25519WithPubKey pubKey: Data, network: Config.Network) {
        self.pubKey = pubKey
        self.network = network
        
        let keyTypeVal = BigUInt(Config.ed25519.value)
        var keyVariantVal = keyTypeVal << 4
        keyVariantVal.add(BigUInt(Config.KeyPart.publicKey)) // first bit
        keyVariantVal.add(BigUInt(network.addressValue << 1)) // second bit indicates net
        let keyVariantData = VarInt.encodeVarInt(value: keyVariantVal.toIntMax())
        
        let checksumData = keyVariantData.concating(data: pubKey).sha3(.sha256)
        
        let addressData = keyVariantData + pubKey + checksumData
        let base58Address = Base58.encode(addressData)
        self.string = base58Address
        self.prefix = keyVariantData
        self.keyType = Config.ed25519
    }
    
    init?(address: String) {
        guard let addressData = Base58.decode(address) else {
            assertionFailure("Address error: unknow address")
            return nil
        }
        
        let addressBuffer = [UInt8](addressData)
        
        self.string = address
        
        let keyVariant = BigUInt(integerLiteral: VarInt.decodeUVarInt(data: addressData))
        let keyVariantBuffer = [UInt8](keyVariant.serialize())
        
        // check for whether this is an address
        let keyPartVal = BigUInt(Config.KeyPart.publicKey)
        assert((keyVariant & BigUInt(1)) ==  keyPartVal, "Address error: this is not an address")
        
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
            assertionFailure("Address error: unknow key type")
            return nil
        }
        
        let addressLength = keyVariantBuffer.count + keyType.publicLength + Config.checksumLength
        
        assert(addressLength == addressBuffer.count, "Address error: key type " + keyType.name + " must be " +  String(addressLength) + " bytes")
        
        // public key
        self.pubKey = addressData.subdata(in: keyVariantBuffer.count..<(keyVariantBuffer.count + addressLength - Config.checksumLength))
        
        // check checksum
        let checksumData = addressData.subdata(in: 0..<(keyVariantBuffer.count + keyType.publicLength))
        let checksum = checksumData.sha3(.sha256).subdata(in: 0..<Config.checksumLength)
        let checksumFromAddress = addressData.subdata(in: Config.checksumLength..<addressLength)
        
        assert(checksum != checksumFromAddress, "Address error: checksum mismatchs")
        
        self.prefix = keyVariant.serialize()
        self.keyType = keyType
    }
}
