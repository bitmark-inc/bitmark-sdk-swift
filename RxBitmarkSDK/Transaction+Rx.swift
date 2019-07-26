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

extension BitmarkSDK.Transaction {
    static func rxGet(transactionID: String) -> Single<Self> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.get(transactionID: transactionID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxGetWithAsset(transactionID: String) -> Single<(Self, Asset)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.getWithAsset(transactionID: transactionID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxList(params: Self.QueryParam) -> Single<([Self]?, [Asset]?, [Block]?)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.list(params: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
