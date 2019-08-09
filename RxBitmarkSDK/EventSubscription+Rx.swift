//
//  EventSubscription+Rx.swift
//  RxBitmarkSDK
//
//  Created by Anh Nguyen on 7/26/19.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import RxSwift
import BitmarkSDK
import SwiftCentrifuge

public extension BitmarkSDK.EventSubscription {
    
    func rxConnect(_ signable: KeypairSignable) -> Completable {
        return Completable.create { (completable) -> Disposable in
            do {
                try self.connect(signable)
                completable(.completed)
            } catch let e {
                completable(.error(e))
            }
            
            return Disposables.create()
        }
    }
    
    func rxDisconnect() -> Completable {
        return Completable.create { (completable) -> Disposable in
            self.disconnect()
            completable(.completed)
            
            return Disposables.create()
        }
    }
  
    func rxListenNewBlock() -> Observable<Int> {
        return Observable<Int>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.listenNewBlock(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
    
    func rxListenBitmarkChanged() -> Observable<BitmarkChangedInfo> {
        return Observable<BitmarkChangedInfo>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.listenBitmarkChanged(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
    
    func rxListenBitmarkPending() -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.listenBitmarkPending(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
    
    func rxListenTxPending() -> Observable<PendingTxInfo> {
        return Observable<PendingTxInfo>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.listenTxPending(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
    
    func rxListenTransferOffer() -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.listenTransferOffer(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
}
