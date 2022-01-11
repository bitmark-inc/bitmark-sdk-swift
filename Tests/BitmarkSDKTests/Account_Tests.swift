//
//  Account_Tests.swift
//  BitmarkSDKTests
//
//  Created by Anh Nguyen on 10/31/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class Account_Tests: XCTestCase {
    
    override class func setUp() {
        BitmarkSDK.initialize(config: SDKConfig(apiToken: "bmk-lljpzkhqdkzmblhg",
                                                network: .testnet,
                                                urlSession: URLSession.shared))
    }
    
    func testAccountCreate() {
        do {
            let a = try Account()
            
            XCTAssertEqual(a.seed?.core.count, Config.SeedConfigV2.seedLength)
            XCTAssertEqual(a.authKey.privateKey.count, KeyType.ed25519.privateLength)
        }
        catch {
            XCTFail()
        }
    }
    
    func testAccountSeed() {
        do {
            let seedString = "9J87BSeH4cpWiWyUodcCZddPCaWW7uxTq"
            let a = try Account(fromSeed: seedString)
            
            XCTAssertEqual(a.seed?.core.count, Config.SeedConfigV2.seedLength)
            XCTAssertEqual(a.authKey.privateKey.count, KeyType.ed25519.privateLength)
            
            let seed = try a.getSeed()
            XCTAssertEqual(seed, seedString)
        }
        catch {
            XCTFail()
        }
    }
    
    func testSignAndVerify() {
        do {
            let defaultAccount = try Account()
            let wrongNetworkAccount = try Account(network: .livenet)
            
            let message = "This is a sample message".data(using: .utf8)!
            
            let defaultSignature = try defaultAccount.sign(message: message)
            let wrongNetworkSignature = try wrongNetworkAccount.sign(message: message)
            
            // Verify
            XCTAssertTrue(defaultAccount.address.verify(message: message, signature: defaultSignature))
            XCTAssertFalse(wrongNetworkAccount.address.verify(message: message, signature: wrongNetworkSignature))
            XCTAssertFalse(defaultAccount.address.verify(message: message, signature: Data()))
            XCTAssertFalse(defaultAccount.address.verify(message: Data(), signature: defaultSignature))
        }
        catch {
            XCTFail()
        }
    }
}
