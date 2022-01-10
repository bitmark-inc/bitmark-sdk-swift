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

public extension BitmarkSDK.Asset {
    static func rxGet(assetID: String) -> Single<Asset> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Asset.get(assetID: assetID)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxList(params: Asset.QueryParam) -> Single<([Asset]?)> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Asset.list(params: params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func rxRegister(_ params: RegistrationParams) -> Single<String> {
        return Single.create { (single) -> Disposable in
            do {
                single(.success(try Asset.register(params)))
            } catch let error {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
