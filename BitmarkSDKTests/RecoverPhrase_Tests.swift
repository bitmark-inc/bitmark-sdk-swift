//
//  RecoverPhrase_Tests.swift
//  BitmarkSDKTests
//
//  Created by Anh Nguyen on 10/31/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class RecoverPhrase_Tests: XCTestCase {
    
    let testData = [
        [
            "Hex":    "000000000000000000000000000000000000000000000000000000000000000000",
            "Phrase": "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon",
            ],
        [
            "Hex":    "000000000000000000000000000000000000000000000000000000000000000001",
            "Phrase": "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon ability",
            ],
        [
            "Hex":    "001fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            "Phrase": "abandon zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            ],
        [
            "Hex":    "002003ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            "Phrase": "ability abandon zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            ],
        [
            "Hex":    "002004008010020040080100200400801002004008010020040080100200400801",
            "Phrase": "ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability ability",
            ],
        [
            "Hex":    "002007ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            "Phrase": "ability ability zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            ],
        [
            "Hex":    "003fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            "Phrase": "ability zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            ],
        [
            "Hex":    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            "Phrase": "zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            ],
        [
            "Hex":    "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff800",
            "Phrase": "zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo abandon",
            ],
        [
            "Hex":    "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff801",
            "Phrase": "zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo ability",
            ],
        [
            "Hex":    "6ddaa7d75a04d05183db7ee239652a9f0bb497a4a0c248c9171055cd07daa71634",
            "Phrase": "horse steel volume reduce escape churn author hurt timber sleep enjoy dignity robust envelope myth blue emotion emerge series process spare unhappy ordinary shoot",
            ],
        [
            "Hex":    "36e3b2c1a7bc5f38b98ae41353f948c31d6bd5282459534cc89c5aec0e81dbbd4a",
            "Phrase": "dad budget race exhaust shine ordinary tower frame battle panther fall mail stove tunnel party menu fashion green check remind science domain humble power",
            ]
    ]
    
    func testToPhrase() {
        do {
            for testDic in testData {
                let data = testDic["Hex"]!.hexDecodedData
                let phrase = testDic["Phrase"]!.split(separator: " ").map {$0.lowercased()}
                let recoverPhrase = try RecoverPhrase.createPhrase(fromData: data)
                XCTAssertEqual(phrase, recoverPhrase)
            }
        }
        catch let e{
            XCTFail(e.localizedDescription)
        }
    }
    
    func testFromPhrase() {
        do {
            for testDic in testData {
                let data = testDic["Hex"]!.hexDecodedData
                let phrase = testDic["Phrase"]!.split(separator: " ").map {$0.lowercased()}
                let recoverData = try RecoverPhrase.recoverSeed(fromPhrase: phrase)
                XCTAssertEqual(data, recoverData)
            }
        }
        catch let e{
            XCTFail(e.localizedDescription)
        }
    }
}

