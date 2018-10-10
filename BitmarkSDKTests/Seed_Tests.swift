//
//  Seed_Tests.swift
//  BitmarkSDKTests
//
//  Created by Anh Nguyen on 10/11/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class Seed_Tests: XCTestCase {
    
    // Testnet seed
    let core1 = "215ee785527df33665bd3a51df18cccf92d4e24628ca0619a26fd082fb0a29be"
    let seed1 = "5XEECsKPsXJEZRQJfeRU75tEk72WMs87jW1x9MhT6jF3UxMVaAZ7TSi"
    let network1 = Network.testnet
    let version1 = 1
    
    // Livenet seed
    let core2 = "651bf8bc9f8e8fce9d18ac62fb93a483a06d1b43fdf28d1afa5578bc7518a6ac"
    let seed2 = "5XEECqtUz83pdgg2L11UrMBb34za1rhi12GNFmRRrd8Qudi1nkJbNxk"
    let network2 = Network.livenet
    let version2 = 1
    
    // Bad seed
    let badSeed = "5XEECqtUz83pdgg2L11UrMBb34za1rhi12GNFmRRrd8Qudi1nkJsdfvsd"
    
    // Seed v2
    let seedV2 = "5XEEMRom7eEhdZo7K1ha447YK7kwqy4z33t9CmA97QVH7NLYEFJYUa6"
    
    // Bad seed core length
    let badSeedCoreLength = "9J86mRJEyZgVJgrXyb1LQmxzvWMChi3dk"
    
    // MARK:- Asset
    
    func testCorrectSeedTestnet() {
        do {
            let seed = try Seed(fromBase58: seed1)
            
            XCTAssertEqual(seed.core.hexEncodedString, core1)
            XCTAssertEqual(seed.network, network1)
            XCTAssertEqual(seed.version, version1)
        }
        catch {
            XCTFail()
        }
    }
    
    func testCorrectSeedLivenet() {
        do {
            let seed = try Seed(fromBase58: seed2)
            
            XCTAssertEqual(seed.core.hexEncodedString, core2)
            XCTAssertEqual(seed.network, network2)
            XCTAssertEqual(seed.version, version2)
        }
        catch {
            XCTFail()
        }
    }
    
    func testIncorrectVersionSeed() {
        XCTAssertThrowsError(try Seed(fromBase58: seedV2))
    }
    
    func testBadSeed() {
        XCTAssertThrowsError(try Seed(fromBase58: badSeed))
    }
    
    func testBadSeedCoreLength() {
        XCTAssertThrowsError(try Seed(fromBase58: badSeedCoreLength))
    }
    
    func testSeedRecover() {
        do {
            let seed = try Seed(core: core1.hexDecodedData, version: version1, network: Network.testnet)
            XCTAssertEqual(seed.base58String, seed1)
        }
        catch {
            XCTFail()
        }
    }
    
    func testSeedRaw() {
        let seed = Seed(rawValue: seed1)
        XCTAssertNotNil(seed)
        XCTAssertEqual(seed?.rawValue, seed1)
    }
    
    func testSeedInit() {
        do {
            let seed = try Seed(network: .testnet)
            XCTAssertEqual(seed.core.count, Config.SeedConfig.length)
            
            XCTAssertThrowsError(try Seed(version: 2, network: .testnet))
        }
        catch {
            XCTFail()
        }
    }
}
