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
        BitmarkSDK.initialize(config: SDKConfig(apiToken: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjk0NTQ1MDg5NzcsImlhdCI6MTU2NTMyNDk3NywiaXNzIjoiOVEvSllhVkJJOXZmRlp6N0J2VjRNdz09Iiwic3ViIjoiZVhjcHlKcXpxZGdWVk1YRVJMUmh2dEpxWGFWWnZoS0hkcEZLSzdlUnJ4UDlSTXM4cFYifQ.EiIXik49k-DTuRIRYK5nPm6qV9viZupYqlfLxr5n-3wkkABW55InRXnPWHlyDE0Fx0b1gcJg67eifVSNgnKrD6l2JdKEzDBvUfmj41OQxFTJ_hwA25wfYHudnwD_-axtv3LqREYu_jkxNKe6riw3IcX-ve3zvpDnFqA_Ntu75Z10-Hapkz9yhAVI_pp0CKo2qjKNjYB2s21PvQ2r2yifvt_xLTXth-aw61VzRKJfr1mmi97yHoay6Fo89sDmQpxaSxHRTKq2thyGWghXVz49iQozkthMwpMZZ5i9cSyAvr5a-wOcmI8-NZbKNv9RfBwd4bNm_hZFcXSfw_ZaLwmNNw", network: .testnet, urlSession: URLSession.shared))
    }

    func testQueryAsset() {
        do {
            let registrant = "e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog"
            let query = try Asset.newQueryParams()
                .limit(size: 5)
                .registeredBy(registrant: registrant)
            let assets = try Asset.list(params: query)
            XCTAssertTrue(assets.count > 0)
            let asset = assets[0]
            XCTAssertEqual(asset.registrant, registrant)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testQueryAssetsByAssetIds() {
        do {
            let existingAssetIds = [
                "1b9de5312536f90773d112f106e30a6de1a2208869bdab53610e5e6ecfd6837a6398b779222e5e67980ea08d19cb2fd29e1aad83fe2a60206f7938215660a2c9",
                "b509c635b45d2923beda9c8fff51963fefb7492ab9fa89685f05c88c40b63bd8157cf36ab957a6867b448939da43952ccf514526f904ec620d292cfb3b54c681"
            ]
            let query = Asset.newQueryParams().assetIds(existingAssetIds)
            let assets = try Asset.list(params: query)
            XCTAssertTrue(assets.count == 2)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testQueryAssetsByAtAndTo() {
        let limit = 10
        let at: Int64 = 5
        
        do {
            let query = try Asset.newQueryParams().at(at).to(direction: QueryDirection.earlier).limit(size: limit)
            let assets = try Asset.list(params: query)
            
            for asset in assets {
                XCTAssertTrue(asset.offset <= at)
            }
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }

    func testQueryOffering() {
        do {
            let receiver = "fRaDcbnzYCDHofGMfUSPfGerhfRDMpJkGFwvpQtB6WtP9CbE7y"
            let query = try Bitmark.newBitmarkQueryParams()
                .limit(size: 100)
                .offerFrom(receiver)
            let (bitmarks, _) = try Bitmark.list(params: query)
            if bitmarks != nil && bitmarks!.count > 0 {
                XCTAssertEqual(bitmarks?.first?.offer?.from, receiver)
            }
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testGetBitmark() {
        let bitmarkID = "889f46d55ddbf6fae2da6fe14ca31b79ab84fe7cd104de735dc8cf9319eb68b5"
        
        do {
            let bitmark = try Bitmark.get(bitmarkID: bitmarkID)
            XCTAssertEqual(bitmark.id, bitmarkID)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testGetBitmarkWithAsset() {
        let bitmarkID = "889f46d55ddbf6fae2da6fe14ca31b79ab84fe7cd104de735dc8cf9319eb68b5"
        let assetID = "c54294134a632c478e978bcd7088e368828474a0d3716b884dd16c2a397edff357e76f90163061934f2c2acba1a77a5dcf6833beca000992e63e19dfaa5aee2a"
        
        do {
            let (bitmark, asset) = try Bitmark.getWithAsset(bitmarkID: bitmarkID)
            XCTAssertEqual(bitmark.id, bitmarkID)
            XCTAssertEqual(asset.id, assetID)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }

    func testQueryBitmarks() {
        do {
            let issuedBy = "fRaDcbnzYCDHofGMfUSPfGerhfRDMpJkGFwvpQtB6WtP9CbE7y"
            let referencedAssetID = "0233f183bc20f8e5013ecb432e7120cf425c847d297880bea9703a026ca1bfd7a782d51e311972728b94d8ffe13ea919718a46bafe79853ee2cf9f76fb1c5c1d"
            let query = try Bitmark.newBitmarkQueryParams()
                .limit(size: 10)
                .issuedBy(issuedBy)
                .referencedAsset(assetID: referencedAssetID)
                .loadAsset(true)
                .pending(true)
            let (bitmarks, assets) = try Bitmark.list(params: query)
            XCTAssertNotNil(assets)
            XCTAssertEqual(bitmarks?.first?.issuer, issuedBy)
            XCTAssertEqual(assets?.first?.id, referencedAssetID)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testGetTransaction() {
        let transactionID = "c6ca0ad045d519879008e93a6ee4a03af6505167f0fd7c22dd58d721a5486ff6"
        
        do {
            let tx = try Transaction.get(transactionID: transactionID)
            XCTAssertEqual(tx.id, transactionID)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testGetTransactionWithAsset() {
        let transactionID = "c6ca0ad045d519879008e93a6ee4a03af6505167f0fd7c22dd58d721a5486ff6"
        let assetID = "429d88a2bea77f6fb88d7746f679313f6f135ff51c84318a99e9339a5943e32761b85ee11bedfb3d1a40ae2846d82085fd2b515f02ecdd154658df9daa0b0615"
        
        do {
            let (tx, asset) = try Transaction.getWithAsset(transactionID: transactionID)
            XCTAssertEqual(tx.id, transactionID)
            XCTAssertEqual(asset.id, assetID)
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
                .ownedBy(ownedBy)
                .referencedAsset(assetID: referencedAssetID)
                .referencedBitmark(bitmarkID: referencedBitmarkID)
                .loadAsset(true)
            let (txs, assets, _) = try Transaction.list(params: query)
            XCTAssertNotNil(assets)
            XCTAssertEqual(txs.first?.owner, ownedBy)
            XCTAssertEqual(txs.first?.bitmark_id, referencedBitmarkID)
            XCTAssertEqual(txs.first?.asset_id, referencedAssetID)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testQueryTransactionsByBlockNumber() {
        do {
            let blockNumber: Int64 = 100
            let query = try Transaction.newTransactionQueryParams()
                .referencedBlockNumber(blockNumber: blockNumber)
                .pending(true)
                .limit(size: 10)
            
            let (txs, _, _) = try Transaction.list(params: query)
            
            for tx in txs {
                XCTAssertTrue(tx.block_number == blockNumber)
            }
            
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
}
