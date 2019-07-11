//
//  QuerySample.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/17.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK

class QuerySample {
    static func queryBitmarks(params: Bitmark.QueryParam) throws -> ([Bitmark]?, [Asset]?) {
        let (bitmarks, assets) = try Bitmark.list(params: params)
        return (bitmarks, assets)
    }
    
    static func queryBitmark(bitmarkId: String) throws -> Bitmark {
        let bitmark = try Bitmark.get(bitmarkID: bitmarkId)
        return bitmark
    }
    
    static func queryAssets(params: Asset.QueryParam) throws -> [Asset] {
        let assets = try Asset.list(params: params)
        return assets
    }
    
    static func queryAsset(assetId: String) throws -> Asset {
        let asset = try Asset.get(assetID: assetId)
        return asset
    }
    
    static func queryTransactions(params: Transaction.QueryParam) throws -> ([Transaction], [Asset]?) {
        let (txs, assets, _) = try Transaction.list(params: params)
        return (txs, assets)
    }
    
    static func queryTransaction(txId: String) throws -> Transaction {
        let tx = try Transaction.get(transactionID: txId)
        return tx
    }
}
