//
//  Issue_Tests.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/23/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class Issue_Tests: XCTestCase {
    
    let assetPk = try! AuthKey(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
    var asset = Asset()
    let issueNonce = UInt64(1475482198529)
    let issuePk = try! AuthKey.init(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
    let issueSignature = "ea32dbdd484159d5dffb37a7d62282e85f83e478594acbdbf2254a81c4efae9f9c869fee52c652d40700b57da09f5a677058a441937976cd0f65b2e32f61cb0a"
    
    override func setUp() {
        super.setUp()
        
        try! asset.set(name: "this is name")
        try! asset.set(metadata: ["description": "this is description"])
        try! asset.set(fingerPrint: "Test Bitmark Lib 11")
        try! asset.sign(withPrivateKey: assetPk)
    }
    
    // MARK:- Asset
    
    func testIssue() {
        var issue = Issue()
        do {
            issue.set(asset: asset)
            issue.set(nonce: issueNonce)
            try issue.sign(privateKey: issuePk)
            
            XCTAssert(issue.isSigned)
            XCTAssertEqual(issue.owner?.string, issuePk.address.string)
            XCTAssertEqual(issue.signature?.hexEncodedString, issueSignature)
            XCTAssertEqual(issue.asset?.id, asset.id)
        }
        catch {
            XCTFail()
        }
    }
}
