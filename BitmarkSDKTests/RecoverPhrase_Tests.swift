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
    
    let testDataV1 = [
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
    
    let testDataV2 = [
        [
            "Phrase":  "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon",
            "Base58":  "9J8739KB7PSFpEoPsbo2DcdQMCDLvFyB8",
            "Hex":     "000000000000000000000000000000000",
            "Network": "LIVENET",
            "Key10":   "68a63043622ac1e25a0c3d088d1928cc6a5adc36c333afc9c667e059fede4bd2",
            ],
        [
            "Phrase":  "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon ability",
            "Base58":  "9J8739KB7PSFpEoPsbo2DcdQMCF9Ru2zJ",
            "Hex":     "000000000000000000000000000000001",
            "Network": "LIVENET",
            "Key10":   "c0123818c68f18a2d1a2cd8ede05dfd2f6e4e7f12e44c14a8baeaf5fd18275a6",
            ],
        [
            "Phrase":  "abandon zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            "Base58":  "9J8739m2q1MEFN6HkyE25JYhb1VQvfoXY",
            "Hex":     "001ffffffffffffffffffffffffffffff",
            "Network": "ERROR",
            "Key10":   "ERROR",
            ],
        [
            "Phrase":  "ability abandon zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            "Base58":  "9J8739m3ZUkcsjse1EtyKyAfXb8WBsAow",
            "Hex":     "002003fffffffffffffffffffffffffff",
            "Network": "ERROR",
            "Key10":   "ERROR",
            ],
        [
            "Phrase":  "ability ability ability ability ability ability ability ability ability ability ability ability",
            "Base58":  "9J8739m3ZVxRBfXB8FDVZNuGYkSd3SBv3",
            "Hex":     "002004008010020040080100200400801",
            "Network": "ERROR",
            "Key10":   "ERROR",
            ],
        [
            "Phrase":  "ability ability zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            "Base58":  "9J8739m4HxA1W7ezFWZvadndUAmYWXVGU",
            "Hex":     "002007fffffffffffffffffffffffffff",
            "Network": "ERROR",
            "Key10":   "ERROR",
            ],
        [
            "Phrase":  "ability zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            "Base58":  "9J873ACtYdGCgVPBeLf1vzTzppoHp32cz",
            "Hex":     "003ffffffffffffffffffffffffffffff",
            "Network": "ERROR",
            "Key10":   "ERROR",
            ],
        [
            "Phrase":  "zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo",
            "Base58":  "9J87JtLihVvw1hMVkLTxjAa6Bf1TA47di",
            "Hex":     "fffffffffffffffffffffffffffffffff",
            "Network": "LIVENET",
            "Key10":   "3812c3dda9255ac646c363b5e6fd15687e3194b31d464c862c3e9d9a9c89efd4",
            ],
        [
            "Phrase":  "horse steel volume reduce escape churn author hurt timber sleep enjoy dignity",
            "Base58":  "9J879u7LPPYUXfu7FDDiLTWK6av5K6FEQ",
            "Hex":     "6ddaa7d75a04d05183db7ee239652a9f0",
            "Network": "ERROR",
            "Key10":   "ERROR",
            ],
        [
            "Phrase":  "dad budget race exhaust shine ordinary tower frame battle panther fall mail",
            "Base58":  "9J876X5USz8d4JjWqEZQgLg14GLfB4wD6",
            "Hex":     "36e3b2c1a7bc5f38b98ae41353f948c31",
            "Network": "ERROR",
            "Key10":   "ERROR",
            ],
        [
            "Phrase":  "during kingdom crew atom practice brisk weird document eager artwork ride then",
            "Base58":  "9J877LVjhr3Xxd2nGzRVRVNUZpSKJF4TH",
            "Hex":     "442f54cd072a9638be4a0344e1a6e5f01",
            "Network": "TESTNET",
            "Key10":   "be4a4a0730e19371edef04d38f9ca8187c376633f906ad602b7716e6d19b8374",
            ],
        [
            "Phrase":  "device link subject enemy quick alpha useless cotton bundle best twice limb",
            "Base58":  "9J876sm4KtT591aXEYmmnWT1P1u5NDP6q",
            "Hex":     "3cb0435fa4fafa0e3c01861e42abad40e",
            "Network": "ERROR",
            "Key10":   "ERROR",
            ],
        [
            "Phrase":  "depend crime cricket castle fun purse announce nephew profit cloth trim deliver",
            "Base58":  "9J876mP7wDJ6g5P41eNMN8N3jo9fycDs2",
            "Hex":     "3ae670cd91c5e15d0254a2abc57ba29d0",
            "Network": "TESTNET",
            "Key10":   "ecb58de83f46a0a9cc3f800fbdfa2542e76f1abbd13ee55af91753b86f0b4180",
            ],
        [
            "Phrase":  "ring immune garage cargo key squeeze please wasp erosion play erupt key",
            "Base58":  "9J87EatAn3yLJxqPcFFQRnbnhGfYdQ6u1",
            "Hex":     "ba0e357d9157a1a7299fbc4cb4c933bd0",
            "Network": "LIVENET",
            "Key10":   "186b1f0237416cea8824a9321f5e183c011b85459ed85f53577a1e0af78f0cf8",
            ],
        [
            "Phrase":  "horse steel volume reduce escape churn author hurt timber sleep enjoy dignity",
            "Base58":  "9J879u7LPPYUXfu7FDDiLTWK6av5K6FEQ",
            "Hex":     "6ddaa7d75a04d05183db7ee239652a9f0",
            "Network": "ERROR",
            "Key10":   "ERROR",
            ],
        [
            "Phrase":  "file earn crack fever crack differ wreck crazy salon imitate swamp sample",
            "Base58":  "9J878SbnM2GFqAELkkiZbqHJDkAj57fYK",
            "Hex":     "5628a8c72ab31c7bbf8996be8e2f6cdf8",
            "Network": "TESTNET",
            "Key10":   "8267d00a94ade62c34ebc8aecc393ed6c7fdbb02b7cd58d9264286922b4db221",
            ],
        [
            "Phrase":  "absorb lesson capital old logic person glue lend rocket barrel intact miracle",
            "Base58":  "9J873CDHZyye3bsF4yrft4usm42zJrs8X",
            "Hex":     "00d00c884d08394698fbffbb6259d646b",
            "Network": "LIVENET",
            "Key10":   "4a990e462f7aef7d2296dab6b6a6baa79e4ee073c5d6d4b8c142c4f5d40b642c",
            ],
        [
            "Phrase":  "hundred diary business foot issue forward penalty broccoli clerk category ship help",
            "Base58":  "9J879ykQwWijwsrQbGop819AiLqk1Jf1Z",
            "Hex":     "6f27a87c2d776ab7a8a0e32a648718358",
            "Network": "LIVENET",
            "Key10":   "cd98d3d1b38bb26e57fd9e217d374f1c38115d71e1ab92461ba0681980994ae8",
            ],
    ]
    
    func testToPhraseV1() {
        do {
            for testDic in testDataV1 {
                let data = testDic["Hex"]!.hexDecodedData
                let phrase = testDic["Phrase"]!.split(separator: " ").map {$0.lowercased()}
                let recoverPhrase = try RecoverPhrase.V1.createPhrase(fromData: data)
                XCTAssertEqual(phrase, recoverPhrase)
            }
        }
        catch let e{
            XCTFail(e.localizedDescription)
        }
    }
    
    func testFromPhraseV1() {
        do {
            for testDic in testDataV1 {
                let data = testDic["Hex"]!.hexDecodedData
                let phrase = testDic["Phrase"]!.split(separator: " ").map {$0.lowercased()}
                let recoverData = try RecoverPhrase.V1.recoverSeed(fromPhrase: phrase)
                XCTAssertEqual(data, recoverData)
            }
        }
        catch let e{
            XCTFail(e.localizedDescription)
        }
    }
    
    func testIncorrectPhrase() {
        let phraseWrong1 = ["dad", "budget", "race", "exhaust", "shine", "ordinary"]
        let phraseWrong2 = ["dad", "budget", "race", "exhaust", "shine", "ordinary", "tower", "frame", "aaaaa", "panther", "fall", "mail", "stove", "tunnel", "party", "menu", "fashion", "green", "check", "remind", "science", "domain", "humble", "power"]
        XCTAssertThrowsError(try RecoverPhrase.V1.recoverSeed(fromPhrase: phraseWrong1))
        XCTAssertThrowsError(try RecoverPhrase.V1.recoverSeed(fromPhrase: phraseWrong2))
    }
    
    func testIncorrectData() {
        let data = Common.randomBytes(length: 32)
        XCTAssertThrowsError(try RecoverPhrase.V1.createPhrase(fromData: data))
    }
    
    // MARK:- v2
    
    func testToPhraseV2() {
        for testDic in testDataV2 {
            print("testing: " + testDic["Hex"]!)
            let (phrase, base58, networkString) = v2(hex: testDic["Hex"]!)
            if networkString != "ERROR" {
                XCTAssertEqual(phrase, testDic["Phrase"])
                XCTAssertEqual(base58, testDic["Base58"])
                XCTAssertEqual(networkString, testDic["Network"])
                
                let k10 = key10(hex: testDic["Hex"]!)
                XCTAssertEqual(k10, testDic["Key10"])
            } else {
                XCTAssertEqual(networkString, testDic["Network"])
            }
        }
    }
    
    func v2(hex: String) -> (String, String, String) {
        do {
            let core = hex.hexDecodedData
            let seed = try Seed.fromCore(core, version: .v2, network: .testnet)
            let phrase = seed.recoveryPhrase
            let phraseString = phrase.joined(separator: " ")
            let base58 = seed.base58String
            let network = seed.network
            let networkString = network == Network.livenet ? "LIVENET" : "TESTNET"
            return (phraseString, base58, networkString)
        }
        catch {
            return ("", "", "ERROR")
        }
    }
    
    func key10(hex: String) -> String {
        do {
            let core = hex.hexDecodedData
            let seed = try Seed.fromCore(core, version: .v2, network: .testnet)
            let keys = try SeedV2.seedToKeys(seed: seed.core, keyCount: 10, keySize: 32)
            if keys.0.count != 10 {
                return "ERROR"
            } else {
                let arr = keys.0
                for a in arr {
                    print(a.hexEncodedString)
                }
                return keys.0[9].hexEncodedString
            }
        }
        catch {
            return "ERROR"
        }
    }
}

