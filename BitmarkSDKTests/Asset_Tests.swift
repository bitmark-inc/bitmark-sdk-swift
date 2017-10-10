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
            let randomIndex  = Int(arc4random_uniform(UInt32(letters.characters.count)))
            let a = letters.index(letters.startIndex, offsetBy: randomIndex)
            randomString +=  String(letters[a])
        }
        
        return randomString
    }
    
    struct TestData {
        static let privateKey = try! AuthKey(fromKIF: "Zjbm1pyA1zjpy5RTeHtBqSAr2NvErTxsovkbWs1duVy8yYG9Xr")
        static let name = "this is name"
        static let metadata = "description" + "\u{0000}" + "this is description"
        static let fingerprint = "5b071fe12fd7e624cac31b3d774715c11a422a3ceb160b4f1806057a3413a13c"
        static let signature = "2028900a6ddebce59e29fb41c27b45be57a07177927b24e46662e007ecad066399e87f4dec4eecb45599e9e9186497374978595a36f908b4fed9a51145b6e803"
    }
    
    // MARK:- Asset
    
    func testAsset() {
        var asset = Asset()
        do {
            try asset.set(name: TestData.name)
            try asset.set(metadata: TestData.metadata)
            try asset.set(fingerPrint: TestData.fingerprint)
            
            try asset.sign(withPrivateKey: TestData.privateKey)
            
            XCTAssert(asset.isSigned)
            XCTAssertEqual(asset.name, TestData.name)
            XCTAssertEqual(asset.metadata, TestData.metadata)
            XCTAssertEqual(asset.fingerprint, TestData.fingerprint)
            XCTAssertEqual(asset.registrant, TestData.privateKey.address)
            XCTAssertEqual(asset.signature?.hexEncodedString, TestData.signature)
        }
        catch {
            XCTFail()
        }
    }
}
