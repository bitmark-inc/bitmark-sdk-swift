//
//  Connection.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/26/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

public class Connection {
    public static let shared = Connection()
    fileprivate var pool: Pool?
    fileprivate var isReady = false
    fileprivate var connectionReadyHandler: (() -> Void)?
    
    public func setNetwork(_ network: Network) {
        self.isReady = false
        self.pool = Pool(network: network)
        self.pool!.discover { [weak self] in
            self?.isReady = true
            self?.connectionReadyHandler?()
        }
    }
    
    public func onReady(_ handler: @escaping () -> Void) {
        
        // If connection is ready, just process
        if isReady {
            handler()
        }
        else {
            // Else wait for connection is completed
            connectionReadyHandler = handler
        }
    }
    
    public func call(method: String, params: [String: Any]?, timeout: Int = 10, callbackHandler handler:@escaping ([NodeResult]) -> Void) {
        pool?.call(method: method, params: params, timeout: timeout, callbackHandler: handler)
    }
}
