//
//  Account.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/23/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

public struct Account {
    
    public let core: Data
    let authKey: AuthKey
    
    // MARK:- Basic init
    
    public init(keyType: KeyType = KeyType.ed25519) throws {
        let core = Common.randomBytes(length: keyType.seedLength)
        try self.init(core: core)
    }
    
    public init(core: Data) throws {
        self.core = core
        authKey = try AuthKey(fromKeyPair: core)
    }
    
    public var accountNumber: AccountNumber {
        return authKey.address
    }

    
    // MARK:- Seed
    
    public init(fromSeed seedString: String, version: Int = Config.SeedConfig.version) throws {
        let seed = try Seed(fromBase58: seedString, version: version)
        try self.init(core: seed.core)
    }
    
    public func toSeed(version: Int = Config.SeedConfig.version, network: Network = Network.livenet) throws -> String {
        let seed = try Seed(core: core, version: version, network: network)
        return seed.base58String
    }
    // MARK:- Recover phrase
    
    public init(recoverPhrase phrases: [String]) throws {
        let core = try RecoverPhrase.recoverSeed(fromPhrase: phrases)
        try self.init(core: core)
    }

    public func getRecoverPhrase(withNetwork network: Network = Network.livenet) throws -> [String] {
        var data = Data(bytes: [UInt8(truncatingIfNeeded: network.addressValue)])
        data.append(core)
        return try RecoverPhrase.createPhrase(fromData: data)
    }
}
