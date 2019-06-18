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
        static let accountA = try! Account(version: .v2)
        static let accountB = try! Account(version: .v2)
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
            var assetParams = try Asset.newRegistrationParams(name: "SwiftSDK_test_" + randomString(length: 8),
                                                    metadata: ["Random string": randomString(length: 20)])
            
            let fileContent = randomString(length: 300)
            let fileData = fileContent.data(using: .utf8)!
            XCTAssertNoThrow(try assetParams.setFingerprint(fromData: fileData))
            XCTAssertNoThrow(try assetParams.sign(TestData.accountA))
            
            XCTAssert(assetParams.isSigned)
            XCTAssertEqual(assetParams.registrant, TestData.accountA.getAccountNumber())
            
            let assetID = try Asset.register(assetParams)
            
            // Issue
            let numberOfIssuance = 2
            var issueParams = try Bitmark.newIssuanceParams(assetID: assetID, quantity: numberOfIssuance)
            XCTAssertNoThrow(try issueParams.sign(TestData.accountB))
            let bitmarkIDs = try Bitmark.issue(issueParams)
            
            XCTAssertEqual(bitmarkIDs.count, numberOfIssuance)
            XCTAssertEqual(issueParams.issuances.first!.txId!, bitmarkIDs.first!)
            
            // Separate bitmark ids into two, one to test transfer with single signature, one to test with two signatures
            
            let bitmarkId1 = bitmarkIDs[0]
            while true {
                let issue = try Bitmark.get(bitmarkID: bitmarkId1)
                if issue.status == "settled" {
                    break
                }
                
                sleep(5)
            }
            
            // Transfer with single signature
            var transferParam = try Bitmark.newTransferParams(to: TestData.accountA.getAccountNumber())
            XCTAssertNoThrow(try transferParam.from(bitmarkID: bitmarkId1))
            XCTAssertNoThrow(try transferParam.sign(TestData.accountB))
            let tx1 = try Bitmark.transfer(withTransferParams: transferParam)
            
            // Transfer with two signatures
            let bitmarkId2 = bitmarkIDs[1]
            while true {
                let issue = try Bitmark.get(bitmarkID: bitmarkId2)
                if issue.status == "settled" {
                    break
                }
                
                sleep(5)
            }
            
            var offerParam = try Bitmark.newOfferParams(to: TestData.accountA.getAccountNumber(), info: nil)
            XCTAssertNoThrow(try offerParam.from(bitmarkID: bitmarkId2))
            XCTAssertNoThrow(try offerParam.sign(TestData.accountB))
            XCTAssertNoThrow(try Bitmark.offer(withOfferParams: offerParam))
            
            sleep(2)
            
            let receivingBitmark = try Bitmark.get(bitmarkID: bitmarkId2)
            var responseParams = try Bitmark.newTransferResponseParams(withBitmark: receivingBitmark, action: .accept)
            XCTAssertNoThrow(try responseParams.sign(TestData.accountA))
            XCTAssertNoThrow(try Bitmark.respond(withResponseParams: responseParams))
            
            // Check transfer info
            let transaction1 = try Transaction.get(transactionID: tx1)
            XCTAssertEqual(transaction1.asset_id, assetID)
            XCTAssertEqual(transaction1.bitmark_id, bitmarkId1)
            XCTAssertEqual(transaction1.owner, TestData.accountA.getAccountNumber())
        }
        catch (let e){
            print(e)
            XCTFail()
        }
    }
    
}
