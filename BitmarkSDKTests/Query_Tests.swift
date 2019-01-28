//
//  Query_Tests.swift
//  BitmarkSDKTests
//
//  Created by Anh Nguyen on 9/28/18.
//  Copyright © 2018 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class Query_Tests: XCTestCase {
    
    override func setUp() {
        BitmarkSDK.initialize(config: SDKConfig(apiToken: "bmk-lljpzkhqdkzmblhg", network: .testnet, urlSession: URLSession.shared))
    }

    func testQueryAsset() {
        do {
            let registrant = "e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog"
            let query = try Asset.newQueryParams()
                .limit(size: 100)
                .registeredBy(registrant: registrant)
            let assets = try Asset.list(params: query)
            XCTAssertTrue(assets.count > 0)
            let asset = assets[0]
            XCTAssertEqual(asset.registrant, registrant)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }

    func testQueryOffering() {
        do {
            let receiver = "fRaDcbnzYCDHofGMfUSPfGerhfRDMpJkGFwvpQtB6WtP9CbE7y"
            let query = try Bitmark.newBitmarkQueryParams()
                .limit(size: 100)
                .offer(from: receiver)
            let (bitmarks, _) = try Bitmark.list(params: query)
            XCTAssertEqual(bitmarks?.first?.offer?.from, receiver)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }

    func testQueryBitmarks() {
        do {
            let issuedBy = "fRaDcbnzYCDHofGMfUSPfGerhfRDMpJkGFwvpQtB6WtP9CbE7y"
            let referencedAssetID = "0233f183bc20f8e5013ecb432e7120cf425c847d297880bea9703a026ca1bfd7a782d51e311972728b94d8ffe13ea919718a46bafe79853ee2cf9f76fb1c5c1d"
            let query = try Bitmark.newBitmarkQueryParams()
                .limit(size: 100)
                .issued(by: issuedBy)
                .referenced(toAssetID: referencedAssetID)
                .offer(from: "fRaDcbnzYCDHofGMfUSPfGerhfRDMpJkGFwvpQtB6WtP9CbE7y")
                .offer(to: "fUa4CoUTgsZgztjvH8SVV3efHzNRv7pFmU76oGeQq86Q3snk8H")
                .loadAsset(true)
            let (bitmarks, assets) = try Bitmark.list(params: query)
            XCTAssertNotNil(assets)
            XCTAssertEqual(bitmarks?.first?.issuer, issuedBy)
            XCTAssertEqual(assets?.first?.id, referencedAssetID)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }

    func testQueryTransactions() {
        do {
            let ownedBy = "fRaDcbnzYCDHofGMfUSPfGerhfRDMpJkGFwvpQtB6WtP9CbE7y"
            let referencedAssetID = "3bf6bac6d53a30cfece9597609d1ff1f8397add2c04170895f2f00971f74cc3d81843a71fbc425412a7aecc35fddc88f1983c591f7cf103b05c5f6683c85f421"
            let referencedBitmarkID = "96f3aba21ae69ed5fe8eb5a691f9f30a1cad3c86efc8d9ecfabea3707df4fc9d"
            let query = try Transaction.newTransactionQueryParams()
                .limit(size: 100)
                .owned(by: ownedBy, transient: true)
                .referenced(toAssetID: referencedAssetID)
                .referenced(toBitmarkID: referencedBitmarkID)
                .loadAsset(true)
            let (txs, assets) = try Transaction.list(params: query)
            XCTAssertNotNil(assets)
            XCTAssertEqual(txs.first?.owner, ownedBy)
            XCTAssertEqual(txs.first?.bitmark_id, referencedBitmarkID)
            XCTAssertEqual(txs.first?.asset_id, referencedAssetID)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
}
