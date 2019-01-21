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
    
    func testAccountCreate() {
        do {
            let a = try Account()
            
            XCTAssertEqual(a.seed.core.count, Config.SeedConfigV2.seedLength)
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
            
            XCTAssertEqual(a.seed.core.count, Config.SeedConfigV2.seedLength)
            XCTAssertEqual(a.authKey.privateKey.count, KeyType.ed25519.privateLength)
            
            let seed = try a.toSeed()
            XCTAssertEqual(seed, seedString)
        }
        catch {
            XCTFail()
        }
    }
}
