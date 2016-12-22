//
//  Config.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/16/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public struct KeyType {
    let name: String
    let value: Int
    let publicLength: Int
    let privateLength: Int
    let seedLength: Int
}

public struct Network {
    let name: String
    let addressValue: Int
    let kifValue: Int
    let staticHostName: String
    let staticNodes: [String]
}

public class Config {
    
    // MARK:- Key
    static let ed25519 = KeyType(name: "ed25519",
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
    static let liveNet = Network(name: "livenet",
                          addressValue: 0x00,
                          kifValue: 0x00,
                          staticHostName: "nodes.live.bitmark.com",
                          staticNodes: ["118.163.122.206:3130", "118.163.122.207:3130"])
    
    static let testNet = Network(name: "testnet",
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
    
    struct Transfer {
        static let value = 0x04
    }
}
