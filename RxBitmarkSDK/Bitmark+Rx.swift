//
//  Bitmark+Rx.swift
//  RxBitmarkSDK
//
//  Created by Anh Nguyen on 7/17/19.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import RxSwift
import BitmarkSDK

public extension Reactive where Base == Bitmark {
    static func rxGet(bitmarkID: String) -> Single<Base> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.get(bitmarkID: bitmarkID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxGetWithAsset(bitmarkID: String) -> Single<(Base, Asset)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.getWithAsset(bitmarkID: bitmarkID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxList(params: Base.QueryParam) -> Single<([Base]?, [Asset]?)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.list(params: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxIssue(_ params: IssuanceParams) -> Single<[String]> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.issue(params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxTransfer(_ params: TransferParams) -> Single<String> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.transfer(withTransferParams: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxOffer(_ params: OfferParams) -> Completable {
        return Completable.create { (completable) -> Disposable in
            do {
                try Base.offer(withOfferParams: params)
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxRespond(_ params: OfferResponseParams) -> Single<String?> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.respond(withResponseParams: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}

