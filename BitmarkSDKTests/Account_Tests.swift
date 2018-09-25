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
            
            XCTAssertEqual(a.core.count, KeyType.ed25519.seedLength)
            XCTAssertEqual(a.authKey.privateKey.count, KeyType.ed25519.privateLength)
        }
        catch {
            XCTFail()
        }
    }
    
    func testAccountSeed() {
        do {
            let seedString = "5XEECsKPsXJEZRQJfeRU75tEk72WMs87jW1x9MhT6jF3UxMVaAZ7TSi"
            let a = try Account(fromSeed: seedString)
            
            XCTAssertEqual(a.core.count, KeyType.ed25519.seedLength)
            XCTAssertEqual(a.authKey.privateKey.count, KeyType.ed25519.privateLength)
            
            let seed = try a.toSeed(network: a.authKey.network)
            XCTAssertEqual(seed, seedString)
        }
        catch {
            XCTFail()
        }
    }
}
