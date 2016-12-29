//
//  Pool.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/26/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public class Pool {
    
    let network: Network
    internal var nodes = [Node]()
    fileprivate var availableURLs = [URL]()
    fileprivate var discoverCompletedHandler: (() -> Void)?
    
    init(network: Network) {
        self.network = network
    }
    
    public func replacePool(withNodes nodes: [Node]) {
        self.nodes = nodes
    }
    
    public func refreshPool(completionHandler: (() -> Void)?) {
        // Get url from txt records
        PoolHelper.getNodeURLs(fromNetwork: network) { (urls) in
            
            // Connect to urls
            var nodes = [Node]()
            let dispatchGroup = DispatchGroup()
            
            for url in urls {
                dispatchGroup.enter()
                let node = Node(url: url, finishConnectionHandler: { _ in
                    
                    dispatchGroup.leave()
                })
                nodes.append(node)
            }
            
            dispatchGroup.notify(queue: DispatchQueue.global(), execute: { 
                self.nodes = nodes
                completionHandler?()
            })
        }
    }
    
    internal func discover(_ handler: (() -> Void)?) {
        // Assign callback for later using
        discoverCompletedHandler = handler
        
        // Wake up nodes
        
        let dispatchGroup = DispatchGroup()
        for node in nodes {
            if node.connected == false {
                dispatchGroup.enter()
                node.connect({ (success) in
                    dispatchGroup.leave()
                })
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) { [unowned self] in
            // When finished on reconnecting, check and remove dead nodes
            self.removeDeadNodes()
            
            // Get url from txt records
            PoolHelper.getNodeURLs(fromNetwork: self.network, handler: { (urls) in
                // Filter url with existing nodes
                let existingUrls = self.nodes.map({ (node) -> URL in
                    return node.url
                })
                
                let newUrls = urls.filter({ (url) -> Bool in
                    return !existingUrls.contains(url)
                })
                
                self.availableURLs = newUrls
                
                // Check and try to connect to more node if needed
                self.connectToMoreNodes()
            })
        }
        
    }
}

extension Pool {
    fileprivate func removeDeadNodes() {
        nodes = nodes.filter { (node) -> Bool in
            return node.connected
        }
    }
    
    fileprivate func connectToMoreNodes() {
        if self.nodes.count < Config.RPCConfig.enoughRequiredNode && self.availableURLs.count > 0 {
            // Get every 5 url and try to connect
            let countToGet = min(Config.RPCConfig.enoughRequiredNode, self.availableURLs.count)
            
            var urlPack = [URL]()
            for _ in 0..<countToGet {
                urlPack.append(availableURLs.popLast()!)
            }
            
            tryConnect(urlPack: urlPack) { [weak self] in
                // After trying, recheck the nodes
                self?.connectToMoreNodes()
            }
        }
        else {
            discoverCompletedHandler?()
        }
    }
    
    fileprivate func tryConnect(urlPack: [URL], completionHandler: (() -> Void)?) {
        let dispatchGroup = DispatchGroup()
        
        for url in urlPack {
            dispatchGroup.enter()
            let node = Node(url: url, finishConnectionHandler: { _ in
                
                dispatchGroup.leave()
            })
            nodes.append(node)
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global(), execute: {
            completionHandler?()
        })
    }
}
