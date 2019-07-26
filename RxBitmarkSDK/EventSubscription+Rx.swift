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

public extension Reactive where Base: BitmarkSDK.EventSubscription {
    func newBlock() -> Observable<Int> {
        return Observable<Int>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.base.listenNewBlock(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
    
    func bitmarkChanged() -> Observable<BitmarkChangedInfo> {
        return Observable<BitmarkChangedInfo>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.base.listenBitmarkChanged(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
    
    func bitmarkPending() -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.base.listenBitmarkPending(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
    
    func txPending() -> Observable<PendingTxInfo> {
        return Observable<PendingTxInfo>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.base.listenTxPending(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
    
    func transferOffer() -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            var sub: CentrifugeSubscription?
            do {
                sub = try self.base.listenTransferOffer(handler: { observer.onNext($0) })
            } catch let e {
                observer.onError(e)
            }
            
            return Disposables.create {
                sub?.unsubscribe()
            }
        }
    }
}
