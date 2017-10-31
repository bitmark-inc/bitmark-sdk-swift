//
//  AccountNumber_Tests.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/20/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class AccountNumber_Tests: XCTestCase {
    
    struct TestData {
        let address: String
        let pubKey: String
        let network: Network
        let type: KeyType
    }
    
    let validData = [TestData(address: "a5fyw6MQT6C6fpCBeSVdCfT3WS8WTTM24meT3nVuHyxJF7yKes",
                              pubKey: "04946802fadd6d7723985ee012f2b02846fc9e5f6d8084f3c3af5407911a9b4a",
                              network: Network.livenet,
                              type: KeyType.ed25519),
                     TestData(address: "dyALPzR7JSeNJybzogVXqrzsjfZos96bLurwMAHtbzjHSzk4yh",
                              pubKey: "04946802fadd6d7723985ee012f2b02846fc9e5f6d8084f3c3af5407911a9b4a",
                              network: Network.testnet,
                              type: KeyType.ed25519)]
    
    let invalidAddress = ["a5fyw6MQT6C6fpCBeSVdCfT3WS8WTTM24meT3nVuHyxJF7yKe", // bad base58 string
                          "c2RAAYPFsmREVPu6E4VaXGDxd3rAAJDohqkhCUPtwzLnnj2fsT", // wrong key part bit
                          "2B55A7Avk7GGXSGtW5cUnyTPXZX4D8d7Ba3aqkAdo66wBSkQ9ry" // unrecognize key type
    ]
    
    // MARK:- Init address tests
    
    func testAbleToCreateAddressLiveNet() {
        let address = AccountNumber(fromPubKey: validData[0].pubKey.hexDecodedData)
        XCTAssertEqual(address.string, validData[0].address)
    }
    
    func testAbleToCreateAddressTestNet() {
        let address = AccountNumber(fromPubKey: validData[1].pubKey.hexDecodedData, network: validData[1].network)
        XCTAssertEqual(address.string, validData[1].address)
    }
    
    // MARK:- Bad cases tests
    
    func testBadBase58String() {
        XCTAssertThrowsError(try AccountNumber(address: invalidAddress[0]))
    }
    
    func testBadPublicKeyString() {
        XCTAssertThrowsError(try AccountNumber(address: invalidAddress[1]))
    }
    
    func testBadUnknowKeyType() {
        XCTAssertThrowsError(try AccountNumber(address: invalidAddress[2]))
    }
    
    // MARK:- Parse live net correctly tests
    
    func testParseAddressLiveNet() {
        do {
            let address = try AccountNumber(address: validData[0].address)
            XCTAssertEqual(address.pubKey.hexEncodedString, validData[0].pubKey)
            XCTAssertEqual(address.network, validData[0].network)
            XCTAssertEqual(address.keyType, validData[0].type)
        }
        catch {
            XCTFail()
        }
    }
    
    func testParseAddressTestNet() {
        do {
            let address = try AccountNumber(address: validData[1].address)
            XCTAssertEqual(address.pubKey.hexEncodedString, validData[1].pubKey)
            XCTAssertEqual(address.network, validData[1].network)
            XCTAssertEqual(address.keyType, validData[1].type)
        }
        catch {
            XCTFail()
        }
    }
}
