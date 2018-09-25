//
//  PrivateKey_Tests.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/21/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class AuthKey_Tests: XCTestCase {
    
    struct TestData {
        let kif: String
        let network: Network
        let type: KeyType
        let address: String
        let privateKey: String
    }
    
    let validData = [TestData(kif: "Zjbm1pyA1zjpy5RTeHtBqSAr2NvErTxsovkbWs1duVy8yYG9Xr",
                              network: Network.livenet,
                              type: KeyType.ed25519,
                              address: "a5fyw6MQT6C6fpCBeSVdCfT3WS8WTTM24meT3nVuHyxJF7yKes",
                              privateKey: "d7007fdf823a8d2d769f5778e6fb2d2c0cca9a104a7d2a7171d0a2eea1f55b7304946802fadd6d7723985ee012f2b02846fc9e5f6d8084f3c3af5407911a9b4a"),
                     TestData(kif: "dd67Uj2rsMC6cEqGoXt6UdigFcMYG9iT64y5pEodDWk8HKUXeM",
                              network: Network.testnet,
                              type: KeyType.ed25519,
                              address: "dyALPzR7JSeNJybzogVXqrzsjfZos96bLurwMAHtbzjHSzk4yh",
                              privateKey: "d7007fdf823a8d2d769f5778e6fb2d2c0cca9a104a7d2a7171d0a2eea1f55b7304946802fadd6d7723985ee012f2b02846fc9e5f6d8084f3c3af5407911a9b4a")]
    
    let invalidKIF = ["bgLwFH11Sfxxnf8NDut9A2wm8zdtZJqfSzrqfYudZWMddYghqX", // wrongKeyIndicator
        "26qWaj1UnppMz6NhxvDsSy2ZVrEQe7wyU34UVusMYPcB2wzhvMt",              // unknowKeyType
        "Zjbm1pyA1zjpy5RTeHtBqSAr2NvErTxsovkbWs1duVy8yYG9Xs",               // wrongChecksum
        "83kQWEJPfyxC7UayrKtFq2fnaUaYuwmzmRUm4FQCqk52DiBab"                 // wrongKey length
    ]
    
    // MARK:- Parse from KIF string
    
    func testParseLivenetKIF() {
        do {
            let privateKey = try AuthKey(fromKIF: validData[0].kif)
            
            XCTAssertEqual(privateKey.network, validData[0].network)
            XCTAssertEqual(privateKey.type, validData[0].type)
            XCTAssertEqual(privateKey.address, validData[0].address)
            XCTAssertEqual(privateKey.privateKey.hexEncodedString, validData[0].privateKey)
        }
        catch {
            XCTFail()
        }
    }
    
    func testParseTestnetKIF() {
        do {
            let privateKey = try AuthKey(fromKIF: validData[1].kif)
            
            XCTAssertEqual(privateKey.network, validData[1].network)
            XCTAssertEqual(privateKey.type, validData[1].type)
            XCTAssertEqual(privateKey.address, validData[1].address)
            XCTAssertEqual(privateKey.privateKey.hexEncodedString, validData[1].privateKey)
        }
        catch {
            XCTFail()
        }
    }
    
    // MARK:- Test failed cases
    
    func testWrongKey() {
        XCTAssertThrowsError(try AuthKey(fromKIF: invalidKIF[0]))
    }
    
    func testUnknowKeyType() {
        XCTAssertThrowsError(try AuthKey(fromKIF: invalidKIF[1]))
    }
    
    func testWrongChecksum() {
        XCTAssertThrowsError(try AuthKey(fromKIF: invalidKIF[2]))
    }
    
    func testWrongKeyLength() {
        XCTAssertThrowsError(try AuthKey(fromKIF: invalidKIF[3]))
    }
    
    // MARK:- Build from key pair
    
    func testAbleCreateFromBuffer() {
        do {
            _ = try AuthKey(fromKeyPairString: "cbfa5516b0375ebf5a6c9401fa3933e7a95545193d11acdf161c439b480577b7")
        }
        catch {
            XCTFail()
        }
    }
    
    func testCreateLivenetFromBufferFunctional() {
        do {
            let privateKey = try AuthKey(fromKeyPairString: validData[0].privateKey,
                                            network: validData[0].network,
                                            type: validData[0].type)
            XCTAssertEqual(privateKey.kif, validData[0].kif)
            let (network, _) = try privateKey.address.parse()
            XCTAssertEqual(network, validData[0].network)
        }
        catch {
            XCTFail()
        }
    }
    
    func testCreateTestnetFromBufferFunctional() {
        do {
            let privateKey = try AuthKey(fromKeyPairString: validData[1].privateKey,
                                            network: validData[1].network,
                                            type: validData[1].type)
            XCTAssertEqual(privateKey.kif, validData[1].kif)
            let (network, _) = try privateKey.address.parse()
            XCTAssertEqual(network, validData[1].network)
        }
        catch {
            XCTFail()
        }
    }
}
