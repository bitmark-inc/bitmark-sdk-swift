//
//  Address_Tests.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/20/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkLib

class Address_Tests: XCTestCase {
    
    struct TestData {
        let address: String
        let pubKey: String
        let network: Network
        let type: KeyType
    }
    
    let validData = [TestData(address: "a5fyw6MQT6C6fpCBeSVdCfT3WS8WTTM24meT3nVuHyxJF7yKes",
                              pubKey: "04946802fadd6d7723985ee012f2b02846fc9e5f6d8084f3c3af5407911a9b4a",
                              network: Config.liveNet,
                              type: Config.ed25519),
                     TestData(address: "dyALPzR7JSeNJybzogVXqrzsjfZos96bLurwMAHtbzjHSzk4yh",
                              pubKey: "04946802fadd6d7723985ee012f2b02846fc9e5f6d8084f3c3af5407911a9b4a",
                              network: Config.testNet,
                              type: Config.ed25519)]
    
    let invalidAddress = ["a5fyw6MQT6C6fpCBeSVdCfT3WS8WTTM24meT3nVuHyxJF7yKe", // bad base58 string
                          "c2RAAYPFsmREVPu6E4VaXGDxd3rAAJDohqkhCUPtwzLnnj2fsT", // wrong key part bit
                          "2B55A7Avk7GGXSGtW5cUnyTPXZX4D8d7Ba3aqkAdo66wBSkQ9ry" // unrecognize key type
    ]
    
    func testBadKeyLength() {
        XCTAssertThrowsError(try Address(address: invalidAddress[0]))
    }
    
    func testAbleToCreateAddressLiveNet() {
        let address = Address(fromPubKey: validData[0].pubKey.hexDecodedData)
        XCTAssertEqual(address.string, validData[0].address)
    }
}
