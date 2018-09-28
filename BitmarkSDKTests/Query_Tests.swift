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
            let receiver = "e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog"
            let query = try Bitmark.newBitmarkQueryParams()
                .limit(size: 100)
                .offer(from: receiver)
            let (bitmarks, _) = try Bitmark.list(params: query)
            XCTAssertEqual(bitmarks.first?.offer?.from, receiver)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testQueryBitmarks() {
        do {
            let issuedBy = "ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva"
            let referencedAssetID = "0e0b4e3bd771811d35a23707ba6197aa1dd5937439a221eaf8e7909309e7b31b6c0e06a1001c261a099abf04c560199db898bc154cf128aa9efa5efd36030c64"
            let query = try Bitmark.newBitmarkQueryParams()
                .limit(size: 100)
                .issued(by: issuedBy)
                .referenced(toAssetID: referencedAssetID)
                .offer(from: "ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
                .offer(to: "ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
                .loadAsset(true)
            let (bitmarks, assets) = try Bitmark.list(params: query)
            XCTAssertNotNil(assets)
            XCTAssertEqual(bitmarks.first?.issuer, issuedBy)
            XCTAssertEqual(assets?.first?.id, referencedAssetID)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testQueryTransactions() {
        do {
            let ownedBy = "eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9"
            let referencedAssetID = "0e0b4e3bd771811d35a23707ba6197aa1dd5937439a221eaf8e7909309e7b31b6c0e06a1001c261a099abf04c560199db898bc154cf128aa9efa5efd36030c64"
            let referencedBitmarkID = "58737de5ad68a535da6277da62d11eb3ed76ff6dd7fc2adf3c42a4096d9a2518"
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
