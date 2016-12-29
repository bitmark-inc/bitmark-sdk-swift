//
//  Pool.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/26/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public class Pool {
    
    internal static func getURL(of txtRecord: TXTRecord) -> URL? {
        let values = txtRecord.keyValue
        
        var address: (ip: String, port: Int)?
        
        guard let bitmarkVersion = values["bitmark"] as? String else {
            return nil
        }
        
        switch bitmarkVersion {
        case "v1":
            address = (values["ip4"] as? String ?? values["ip6"] as! String,
                    Int(values["rpc"] as! String)!)
            break
        case "v2":
            address = (values["a"] as! String,
                       Int(values["r"] as! String)!)
            break
        default:
            break
        }
        
        if let address = address {
            var urlComponent = URLComponents()
            urlComponent.host = address.ip
            urlComponent.port = address.port
            return urlComponent.url
        }
        
        return nil
    }
    
    public static func getNodeURLs(fromNetwork network: Network, handler: @escaping (([URL]) -> Void)) {
        let queue = DispatchQueue(label: "com.bitmark")
        queue.async {
            DNSResolver.resolveTXT(network.staticHostName, handler: { (result) in
                switch result {
                case .success(let records):
                    var result = [URL]()
                    for record in records {
                        if let url = getURL(of: record) {
                            result.append(url)
                        }
                    }
                    handler(result)
                    
                    break
                case .failure(_):
                    handler([])
                    break
                }
            })
        }
    }
    
    // MARK:- Public methods
    
    let network: Network
    fileprivate var nodes = [Node]()
    
    init(network: Network) {
        self.network = network
    }
    
    public func replacePool(withNodes nodes: [Node]) {
        self.nodes = nodes
    }
    
    public func refreshPool(completionHandler: (() -> Void)?) {
        // Get url from txt records
        Pool.getNodeURLs(fromNetwork: network) { (urls) in
            
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
}

extension Pool {
    internal static func convertRPCParams(from rpctransformables: [RPCTransformable]) -> [[String: String]] {
        var result = [[String: String]]()
        for rpctransformable in rpctransformables {
            do {
                let rpcParam = try rpctransformable.getRPCParam()
                result.append(rpcParam)
            }
            catch {
                
            }
        }
        
        return result
    }
}
