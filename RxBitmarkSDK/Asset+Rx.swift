//
//  Asset+Rx.swift
//  RxBitmarkSDK
//
//  Created by Anh Nguyen on 7/17/19.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK
import RxSwift

extension Reactive where Base == Asset {
    static func rxGet(assetID: String) -> Single<Base> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.get(assetID: assetID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxList(params: Base.QueryParam) -> Single<([Base]?)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.list(params: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxRegister(_ params: RegistrationParams) -> Single<String> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Base.register(params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
