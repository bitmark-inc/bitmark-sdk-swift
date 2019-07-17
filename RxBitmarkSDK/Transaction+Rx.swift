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

extension Reactive where Base == Transaction {
    static func rxGet(transactionID: String) -> Single<Base> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.get(transactionID: transactionID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxGetWithAsset(transactionID: String) -> Single<(Base, Asset)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.getWithAsset(transactionID: transactionID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxList(params: Base.QueryParam) -> Single<([Base]?, [Asset]?, [Block]?)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.list(params: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
