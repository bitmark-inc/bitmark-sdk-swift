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

public extension BitmarkSDK.Bitmark {
    static func rxGet(bitmarkID: String) -> Single<Self> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.get(bitmarkID: bitmarkID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxGetWithAsset(bitmarkID: String) -> Single<(Self, Asset)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.getWithAsset(bitmarkID: bitmarkID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxList(params: Self.QueryParam) -> Single<([Self]?, [Asset]?)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.list(params: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxIssue(_ params: IssuanceParams) -> Single<[String]> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.issue(params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxTransfer(_ params: TransferParams) -> Single<String> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.transfer(withTransferParams: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxOffer(_ params: OfferParams) -> Completable {
        return Completable.create { (completable) -> Disposable in
            do {
                try Self.offer(withOfferParams: params)
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
                single(.success(try Self.respond(withResponseParams: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}

