//
//  Transfer_Tests.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/23/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkLib

class Transfer_Tests: XCTestCase {
    
    let assetPk = try! PrivateKey(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
    var asset = Asset()
    
    let issueNonce = UInt64(1475482198529)
    let issuePk = try! PrivateKey.init(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
    var issue = Issue()
    
    let transferPk = try! PrivateKey(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
    
    override func setUp() {
        super.setUp()
        
        try! asset.set(name: "Test Bitmark Lib")
        try! asset.set(metadata: ["description": "this is description"])
        try! asset.set(fingerPrint: "Test Bitmark Lib 11")
        try! asset.sign(withPrivateKey: assetPk)
        
        issue.set(asset: asset)
        issue.set(nonce: 1475482198529)
        try! issue.sign(privateKey: issuePk)
    }
    
    // MARK:- Asset
    
    func testTransfer() {
        var transfer = Transfer()
        do {
            transfer.set(from: issue)
            try transfer.set(to: transferPk.address)
            try transfer.sign(privateKey: issuePk)
            
            XCTAssert(transfer.isSigned)
            XCTAssertEqual(transfer.owner?.string, transferPk.address.string)
            XCTAssertEqual(transfer.preTxId, issue.txId)
        }
        catch {
            XCTFail()
        }
    }
}
