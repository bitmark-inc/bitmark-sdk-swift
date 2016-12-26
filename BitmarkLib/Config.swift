//
//  Config.swift
//  BitmarkLib
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
    public let staticHostName: String
    public let staticNodes: [String]
}

public class Config {
    
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
                          kifValue: 0x00,
                          staticHostName: "nodes.live.bitmark.com",
                          staticNodes: ["118.163.122.206:3130", "118.163.122.207:3130"])
    
    public static let testNet = Network(name: "testnet",
                          addressValue: 0x01,
                          kifValue: 0x01,
                          staticHostName: "nodes.test.bitmark.com",
                          staticNodes: ["118.163.120.178:3566", "118.163.120.176:3130"])
    
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
}
