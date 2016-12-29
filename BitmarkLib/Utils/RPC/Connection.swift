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
    
//    public func startConnection(from urls: [URL], completionHandler:@escaping (() -> Void)) {
//        
//        let dispatchGroup = DispatchGroup()
//        
//        for url in urls {
//            dispatchGroup.enter()
//            let node = Node(url: url, finishConnectionHandler: { _ in
//                dispatchGroup.leave()
//            })
//            nodes.append(node)
//        }
//        
//        dispatchGroup.notify(queue: DispatchQueue.main, execute: completionHandler)
//    }
    
    
    
    public func call(method: String, params: [String: Any]?, timeout: Int = 10, callbackHandler handler:@escaping ([NodeResult]) -> Void) {
        if pool == nil {
            handler([])
            print("No pool was assigned")
        }
        
        let dispatchGroup = DispatchGroup()
        var results = [NodeResult]()
        for node in pool!.nodes {
            if node.connected {
                dispatchGroup.enter()
                let id = UUID().uuidString
                node.call(id: id, method: method, params: params, callbackHandler: { (result) in
                    results.append(result)
                    dispatchGroup.leave()
                })
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) { 
            handler(results)
        }
    }
}
