//
//  Config.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/16/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public struct KeyType {
    public let name: String
    public let value: Int
    public let publicLength: Int
    public let privateLength: Int
    public let seedLength: Int
}

public struct Network {
    public let name: String
    public let addressValue: Int
    public let kifValue: Int
}

public struct Config {
    
    // MARK:- Key
    public static let ed25519 = KeyType(name: "ed25519",
                          value: 0x01,
                          publicLength: 32,
                          privateLength: 64,
                          seedLength: 32)
    
    static let keyTypes = [ed25519]
    
    struct KeyPart {
        static let privateKey = 0x00
        static let publicKey = 0x01
    }
    
    static let checksumLength = 4
    
    // MARK:- Networks
    public static let liveNet = Network(name: "livenet",
                          addressValue: 0x00,
                          kifValue: 0x00)
    
    public static let testNet = Network(name: "testnet",
                          addressValue: 0x01,
                          kifValue: 0x01)
    
    public static let devNet = Network(name: "devnet",
                                       addressValue: 0x01,
                                       kifValue: 0x01)
    
    static let networks = [liveNet, testNet]
    
    // MARK:- Record
    struct AssetConfig {
        static let value = 0x02
        static let maxName = 64
        static let maxMetadata = 2048
        static let maxFingerprint = 1024
    }
    
    struct IssueConfig {
        static let value = 0x03
    }
    
    struct TransferConfig {
        static let value = 0x04
    }
    
    // MARK:- Currency
    struct CurrencyConfig {
        static let bitcoin = 0x01
    }
    
    public struct SeedConfig {
        public static let magicNumber: [UInt8] = [0x5a, 0xfe]
        public static let length = 32
        public static let checksumLength = 4
        public static let pKeyNonceLength = 24
        public static let pKeyCounterLength = 16
        public static let version = 0x01
        public static let networkLength = 1
    }
}
