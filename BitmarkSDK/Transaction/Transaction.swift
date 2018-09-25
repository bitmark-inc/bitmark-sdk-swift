//
//  Transaction.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 9/25/18.
//  Copyright © 2018 Bitmark. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    let id: String
    let bitmark_id: String
    let asset_id: String
    let owner: String
    let status: String
    let block_number: String
    let offset: String
}

extension Transaction {
    // MARK:- Query
    public static func get(transactionID: String, completionHandler: @escaping (Bitmark?, Error?) -> Void) {
        let api = API()
        DispatchQueue.global().async {
            do {
                let bitmark = try api.get(bitmarkID: bitmarkID)
                completionHandler(bitmark, nil)
            } catch let e {
                completionHandler(nil, e)
            }
        }
    }
    
    public static func newBitmarkQueryParams() -> QueryParam {
        return QueryParam(queryItems: [URLQueryItem]())
    }
    
    public static func list(params: QueryParam, completionHandler: @escaping ([Bitmark]?, [Asset]?, Error?) -> Void) {
        let api = API()
        DispatchQueue.global().async {
            do {
                let (bitmarks, assets) = try api.listBitmark(builder: params)
                completionHandler(bitmarks, assets, nil)
            } catch let e {
                completionHandler(nil, nil, e)
            }
        }
    }
}
