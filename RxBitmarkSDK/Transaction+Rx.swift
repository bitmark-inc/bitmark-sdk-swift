//
//  Transaction+Rx.swift
//  RxBitmarkSDK
//
//  Created by Anh Nguyen on 7/17/19.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK
import RxSwift

public extension BitmarkSDK.Transaction {
    static func rxGet(transactionID: String) -> Single<Transaction> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Transaction.get(transactionID: transactionID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxGetWithAsset(transactionID: String) -> Single<(Transaction, Asset)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Transaction.getWithAsset(transactionID: transactionID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxList(params: Transaction.QueryParam) -> Single<([Transaction], [Asset]?, [Block]?)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Transaction.list(params: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
