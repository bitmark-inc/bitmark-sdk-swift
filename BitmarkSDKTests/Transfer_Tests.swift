//
//  Transfer_Tests.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/23/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class Transfer_Tests: XCTestCase {
    
//    let assetPk = try! AuthKey(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
//    var asset = Asset()
//    
//    let issueNonce = UInt64(1475482198529)
//    let issuePk = try! AuthKey.init(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
//    var issue = Issue()
//    
//    let transferPk = try! AuthKey(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
//    
    override func setUp() {
        BitmarkSDK.initialize(config: SDKConfig(apiToken: "bmk-lljpzkhqdkzmblhg", network: .testnet, urlSession: URLSession.shared))
    }
//    
//    // MARK:- Asset
//    
//    func testTransfer() {
//        var transfer = Transfer()
//        do {
//            transfer.set(from: issue)
//            try transfer.set(to: transferPk.address)
//            try transfer.sign(privateKey: issuePk)
//            
//            XCTAssert(transfer.isSigned)
//            XCTAssertEqual(transfer.owner?.string, transferPk.address.string)
//            XCTAssertEqual(transfer.preTxId, issue.txId)
//        }
//        catch {
//            XCTFail()
//        }
//    }
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
    
    func testRekey() {
        do {
            let accountFrom = try Account()
            let accountTo = try Account()

            print(try accountFrom.getSeed())
            print(try accountTo.getSeed())

            // Issue several bitmarks from accountFrom
            var assetParams = try Asset.newRegistrationParams(name: "SwiftSDK__rekey_test_" + randomString(length: 8),
                                                              metadata: ["Random string": randomString(length: 20)])

            let fileContent = randomString(length: 300)
            let fileData = fileContent.data(using: .utf8)!
            XCTAssertNoThrow(try assetParams.setFingerprint(fromData: fileData))
            XCTAssertNoThrow(try assetParams.sign(accountFrom))

            let assetID = try Asset.register(assetParams)

            // Issue
            let numberOfIssuance = 10
            var issueParams = try Bitmark.newIssuanceParams(assetID: assetID, quantity: numberOfIssuance)
            XCTAssertNoThrow(try issueParams.sign(accountFrom))
            XCTAssertNoThrow(try Bitmark.issue(issueParams))

            // Ensure all bitmarks are confirmed
            var shouldContinue = true
            while shouldContinue {
                let bitmarkAccountFromQuery = Bitmark.newBitmarkQueryParams()
                    .ownedBy(accountFrom.getAccountNumber())
                    .pending(true)
                let (bitmarkAccountFrom, _) = try Bitmark.list(params: bitmarkAccountFromQuery)
                guard let bitmarks = bitmarkAccountFrom else {
                    continue
                }

                shouldContinue = false
                for bitmark in bitmarks {
                    if bitmark.status != "settled" {
                        shouldContinue = true
                        break
                    }
                }

                sleep(5)
            }

            // Rekey
            Migration.rekey(from: accountFrom, to: accountTo) { (_, error) in
                XCTAssertNil(error)
            }
        }
        catch let e {
            XCTFail(e.localizedDescription)
        }
    }
}
