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

extension BitmarkSDK.Asset {
    static func rxGet(assetID: String) -> Single<Self> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.get(assetID: assetID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxList(params: Self.QueryParam) -> Single<([Self]?)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.list(params: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxRegister(_ params: RegistrationParams) -> Single<String> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Self.register(params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
