//
//  Address.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/16/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public typealias AccountNumber = String

public extension AccountNumber {
    public func isValid() -> Bool {
        return Account.isValidAccountNumber(accontNumber: self)
    }
    
    public func parse() throws -> (network: Network, pubkey: Data) {
        return try Account.parseAccountNumber(accountNumber: self)
    }
}

internal extension AccountNumber {
    func parseAndVerifyAccountNumber() throws -> (network: Network, prefix: Data, pubkey: Data) {
        guard let addressData = Base58.decode(self) else {
            throw(BMError("Address error: unknow address"))
        }
        
        let addressBuffer = [UInt8](addressData)
        
        let (_keyVariant, _keyVariantLength) = addressData.toVarint64WithLength()
        guard let keyVariant = _keyVariant,
            let keyVariantLength = _keyVariantLength else {
                throw(BMError("Address error: this is not an address"))
        }
        
        // check for whether this is an address
        let keyPartVal = Config.KeyPart.publicKey
        if (keyVariant & 1) !=  keyPartVal {
            throw(BMError("Address error: this is not an address"))
        }
        
        // detect network
        let networkVal = (keyVariant >> 1) & 0x01
        var network: Network
        
        if networkVal == UInt64(Network.livenet.rawValue) {
            network = Network.livenet
        }
        else {
            network = Network.testnet
        }
        
        // key type
        let keyTypeVal = (keyVariant >> 4) & 0x07
        
        guard let keyType = Common.getKey(byValue: keyTypeVal) else {
            throw(BMError("Address error: unknow key type"))
        }
        
        let addressLength = keyVariantLength + keyType.publicLength + Config.checksumLength
        
        if addressLength != addressBuffer.count{
            throw(BMError("Address error: key type " + keyType.name + " must be " +  String(addressLength) + " bytes"))
        }
        
        // public key
        let pubKey = addressData.slice(start: keyVariantLength, end: (addressLength - Config.checksumLength))
        
        // check checksum
        let checksumData = addressData.slice(start: 0, end: keyVariantLength + keyType.publicLength)
        let checksum = checksumData.sha3(.sha256).slice(start: 0, end: Config.checksumLength)
        let checksumFromAddress = addressData.slice(start: addressLength - Config.checksumLength, end: addressLength)
        
        if checksum != checksumFromAddress {
            throw(BMError("Address error: checksum mismatchs"))
        }
        
        let prefix = Data.varintFrom(keyVariant)
        
        return (network, prefix, pubKey)
    }
    
    static func build(fromPubKey pubKey: Data, network: Network = Network.livenet, keyType: KeyType = KeyType.ed25519) -> AccountNumber {
        let keyTypeVal = keyType.value
        var keyVariantVal = keyTypeVal << 4
        keyVariantVal |= Config.KeyPart.publicKey // first bit
        keyVariantVal |= (network.rawValue << 1) // second bit indicates net
        let keyVariantData = Data.varintFrom(keyVariantVal)
        
        let checksumData = keyVariantData.concating(data: pubKey).sha3(.sha256).slice(start: 0, end: Config.checksumLength)
        
        let addressData = keyVariantData + pubKey + checksumData
        return Base58.encode(addressData)
    }
    
    func pack() throws -> Data {
        // Parse account number
        let (_, prefix, pubkey) = try self.parseAndVerifyAccountNumber()
        return prefix + pubkey
    }
}

//public struct AccountNumber {
//
//    public let prefix: Data
//    public let pubKey: Data
//    public let network: Network
//    public let string: String
//    public let keyType: KeyType
//
//    public init(fromPubKey pubKey: Data, network: Network = Network.livenet, keyType: KeyType = KeyType.ed25519) {
//        self.pubKey = pubKey
//        self.network = network
//
//        let keyTypeVal = keyType.value
//        var keyVariantVal = keyTypeVal << 4
//        keyVariantVal |= Config.KeyPart.publicKey // first bit
//        keyVariantVal |= (network.rawValue << 1) // second bit indicates net
//        let keyVariantData = Data.varintFrom(keyVariantVal)
//
//        let checksumData = keyVariantData.concating(data: pubKey).sha3(.sha256).slice(start: 0, end: Config.checksumLength)
//
//        let addressData = keyVariantData + pubKey + checksumData
//        let base58Address = Base58.encode(addressData)
//        self.string = base58Address
//        self.prefix = keyVariantData
//        self.keyType = keyType
//    }
//
//    public init(address: String) throws {
//        guard let addressData = Base58.decode(address) else {
//            throw(BMError("Address error: unknow address"))
//        }
//
//        let addressBuffer = [UInt8](addressData)
//
//        self.string = address
//
//        let (_keyVariant, _keyVariantLength) = addressData.toVarint64WithLength()
//        guard let keyVariant = _keyVariant,
//            let keyVariantLength = _keyVariantLength else {
//            throw(BMError("Address error: this is not an address"))
//        }
//
//        // check for whether this is an address
//        let keyPartVal = Config.KeyPart.publicKey
//        if (keyVariant & 1) !=  keyPartVal {
//            throw(BMError("Address error: this is not an address"))
//        }
//
//        // detect network
//        let networkVal = (keyVariant >> 1) & 0x01
//
//        if networkVal == UInt64(Network.livenet.rawValue) {
//            self.network = Network.livenet
//        }
//        else {
//            self.network = Network.testnet
//        }
//
//        // key type
//        let keyTypeVal = (keyVariant >> 4) & 0x07
//
//        guard let keyType = Common.getKey(byValue: keyTypeVal) else {
//            throw(BMError("Address error: unknow key type"))
//        }
//
//        let addressLength = keyVariantLength + keyType.publicLength + Config.checksumLength
//
//        if addressLength != addressBuffer.count{
//            throw(BMError("Address error: key type " + keyType.name + " must be " +  String(addressLength) + " bytes"))
//        }
//
//        // public key
//        self.pubKey = addressData.slice(start: keyVariantLength, end: (addressLength - Config.checksumLength))
//
//        // check checksum
//        let checksumData = addressData.slice(start: 0, end: keyVariantLength + keyType.publicLength)
//        let checksum = checksumData.sha3(.sha256).slice(start: 0, end: Config.checksumLength)
//        let checksumFromAddress = addressData.slice(start: addressLength - Config.checksumLength, end: addressLength)
//
//        if checksum != checksumFromAddress {
//            throw(BMError("Address error: checksum mismatchs"))
//        }
//
//        self.prefix = Data.varintFrom(keyVariant)
//        self.keyType = keyType
//    }
//
//    public func pack() -> Data {
//        return prefix + pubKey
//    }
//}

public extension Account {
    public static func parseAccountNumber(accountNumber: AccountNumber) throws -> (network: Network, pubkey: Data) {
        let (network, _, pubkey) = try accountNumber.parseAndVerifyAccountNumber()
        return (network, pubkey)
    }
    
    public static func isValidAccountNumber(accontNumber: AccountNumber) -> Bool {
        do {
            let (network, _) = try parseAccountNumber(accountNumber: accontNumber)
            return network == globalConfig.network
        } catch let e {
            print(e)
            return false
        }
    }
}
