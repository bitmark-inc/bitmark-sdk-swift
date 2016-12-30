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
    fileprivate var jobQueue = JobQueue()
    
    init(network: Network) {
        self.network = network
        
        jobQueue.jobStartHandler = { [weak self] finishHandler in
            self?.discover(finishHandler)
        }
    }
    
    internal func replacePool(withNodes nodes: [Node]) {
        self.nodes = nodes
    }
    
    internal func refreshPool(completionHandler: (() -> Void)?) {
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
        
        print("Wake up nodes")
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
            
            if self.nodes.count >= Config.RPCConfig.enoughRequiredNode {
                // Wakeup enough nodes for connection
                print("Wakeup enough nodes for connection")
                handler?()
                return
            }
            
            print("Going to get more url from txt records")
            
            // Get url from txt records
            PoolHelper.getNodeURLs(fromNetwork: self.network, handler: { (urls) in
                print("Filter url with existing nodes")
                // Filter url with existing nodes
                let existingUrls = self.nodes.map({ (node) -> URL in
                    return node.url
                })
                
                let newUrls = urls.filter({ (url) -> Bool in
                    return !existingUrls.contains(url)
                })
                
                self.availableURLs = newUrls
                
                // Check and try to connect to more node if needed
                print("Check and try to connect to more node if needed")
                self.connectToMoreNodes()
            })
        }
        
    }
    
    internal func call(method: String, params: [String: Any]?, timeout: Int = 10, callbackHandler handler:@escaping ([NodeResult]) -> Void) {
        print("Enqueue request: " + method)
        
        let job = Job { [unowned self] (completionHandler) in
            let dispatchGroup = DispatchGroup()
            var results = [NodeResult]()
            for node in self.nodes {
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
                completionHandler?()
            }
        }
        
        self.jobQueue.enqueue(job: job)
        
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
            // Check for available urls
            if self.availableURLs.count < Config.RPCConfig.enoughRequiredNode - self.nodes.count
            && self.nodes.count >= Config.RPCConfig.minimumRequiredNode {
                // Incase remain available nodes are less than required, we should accept
                discoverCompletedHandler?()
            }
            
            
            // Get every 5 urls and try to connect
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
    
    private func closeNodesConnection() {
        print("Close all socket connnection")
        for node in nodes {
            if node.connected {
                node.disconnect()
            }
        }
    }
}
