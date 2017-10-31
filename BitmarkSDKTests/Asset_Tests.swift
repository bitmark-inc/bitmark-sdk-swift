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
    
    func testFingerprint() {
        let data = "9d42e2cc2973485fdeda1a435986ed117d420da1d540c30d5fb6fc963276b9f3487a485076f6ac2ad3c05cd8e9efd3972860c5564d4b5807a0bd340248aff84ee8629709bee7711b681c0557f1865aefb0e2a348ea0c8133c257960edf90cb42752910b4bf1d198f771a8ed64c49b4878f391ab6f832db05b0d1bff7077c8601".hexDecodedData
        let fingerprint = "013e2a0aa3e49d470d52ee576a1a1a4d19d922d040dee2068d092c4c57f795781f3e66697078604e788f2276011550964672c2199c75d5d483aa9272ae453a6b4a"
        XCTAssertEqual(fingerprint, FileUtil.Fingerprint.computeFingerprint(data: data))
    }
}
