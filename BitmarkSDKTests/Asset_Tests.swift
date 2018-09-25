//
//  Asset_Tests.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/22/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class Asset_Tests: XCTestCase {
    
    func makeRandomString(length: Int) -> String {
        
        var randomString = ""
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for _ in 1...length {
            let randomIndex  = Int(arc4random_uniform(UInt32(letters.count)))
            let a = letters.index(letters.startIndex, offsetBy: randomIndex)
            randomString +=  String(letters[a])
        }
        
        return randomString
    }
    
    struct TestData {
        static let accountA = try! Account(fromSeed: "5XEECttxvRBzxzAmuV4oh6T1FcQu4mBg8eWd9wKbf8hweXsfwtJ8sfH")
        static let accountB = try! Account(fromSeed: "5XEECt6Mhj8Tanb9CDTGHhTQ7RqbS5LHD383LRK6QGDuj8mwfUU6gKs")
        static let accountNumberA = AccountNumber("e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog")
        static let accountNumberB = AccountNumber("f3TnfGTVgNjrWKN6QH3xqiSW6G2Afe5wGQ8WM3wWDQyHEpicDX")
        static let name = "this is name"
        static let metadata = ["description": "this is description"]
        static let fingerprintData = "5b071fe12fd7e624cac31b3d774715c11a422a3ceb160b4f1806057a3413a13c"
        static let signature = "2028900a6ddebce59e29fb41c27b45be57a07177927b24e46662e007ecad066399e87f4dec4eecb45599e9e9186497374978595a36f908b4fed9a51145b6e803"
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    override func setUp() {
        BitmarkSDK.initialize(config: SDKConfig(apiToken: "bmk-lljpzkhqdkzmblhg", network: .testnet, urlSession: URLSession.shared))
    }
    
    // MARK:- Asset
    
    func testAssetAndIssue() {
        do {
            var assetParams = try Asset.newRegistrationParams(name: "SwiftSDK test" + randomString(length: 8),
                                                    metadata: ["Random string": randomString(length: 20)])
            
            let fileContent = randomString(length: 300)
            let fileData = fileContent.data(using: .utf8)!
            XCTAssertNoThrow(try assetParams.setFingerprint(fromData: fileData))
            XCTAssertNoThrow(try assetParams.sign(TestData.accountA))
            
            XCTAssert(assetParams.isSigned)
            XCTAssertEqual(assetParams.registrant, TestData.accountNumberA)
            
            let assetID = try Asset.register(assetParams)
            
            // Issue
            let numberOfIssuance = 1
            let issueParams = try Bitmark.newIssuanceParams(assetID: assetID, owner: TestData.accountNumberB, quantity: numberOfIssuance)
            let bitmarkIDs = try Bitmark.issue(issueParams)
            
            XCTAssertEqual(bitmarkIDs.count, numberOfIssuance)
            XCTAssertEqual(issueParams.issuances.first!.txId!, bitmarkIDs.first!)
            
        }
        catch (let e){
            XCTFail(e.localizedDescription)
        }
    }}
