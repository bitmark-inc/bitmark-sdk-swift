//
//  TransactionQuery.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 9/25/18.
//  Copyright © 2018 Bitmark. All rights reserved.
//

import Foundation

extension Transaction {
    public struct QueryParam: QueryBuildable {
        let queryItems: [URLQueryItem]
        
        public func limit(size: Int) throws -> QueryParam {
            if size > 100 {
                throw("invalid size: max = 100")
            }
            
            let queryItem = URLQueryItem(name: "limit", value: String(size))
            var items = self.queryItems
            items.append(queryItem)
            return QueryParam(queryItems: items)
        }
        
        public func ownedBy(_ owner: String) -> QueryParam {
            var items = self.queryItems
            items.append(URLQueryItem(name: "owner", value: owner))
            return QueryParam(queryItems: items)
        }
        
        public func ownedByWithTransient(_ owner: String) -> QueryParam {
            var items = self.queryItems
            items.append(URLQueryItem(name: "owner", value: owner))
            items.append(URLQueryItem(name: "sent", value: "true"))
            return QueryParam(queryItems: items)
        }
        
        public func referencedAsset(assetID: String) -> QueryParam {
            let queryItem = URLQueryItem(name: "asset_id", value: assetID)
            var items = self.queryItems
            items.append(queryItem)
            return QueryParam(queryItems: items)
        }
        
        public func referencedBitmark(bitmarkID: String) -> QueryParam {
            let queryItem = URLQueryItem(name: "bitmark_id", value: bitmarkID)
            var items = self.queryItems
            items.append(queryItem)
            return QueryParam(queryItems: items)
        }
        
        public func referencedBlockNumber(blockNumber: Int64) -> QueryParam {
            let queryItem = URLQueryItem(name: "block_number", value: String(blockNumber))
            var items = self.queryItems
            items.append(queryItem)
            return QueryParam(queryItems: items)
        }
        
        public func loadAsset(_ loadAsset: Bool) -> QueryParam {
            let queryItem = URLQueryItem(name: "asset", value: String(loadAsset))
            var items = self.queryItems
            items.append(queryItem)
            return QueryParam(queryItems: items)
        }
        
        public func at(_ index: Int64) -> QueryParam {
            let queryItem = URLQueryItem(name: "at", value: String(index))
            var items = self.queryItems
            items.append(queryItem)
            return QueryParam(queryItems: items)
        }
        
        public func to(direction: QueryDirection) -> QueryParam {
            let queryItem = URLQueryItem(name: "to", value: direction.rawValue)
            var items = self.queryItems
            items.append(queryItem)
            return QueryParam(queryItems: items)
        }
        
        public func pending(_ pending: Bool) -> QueryParam {
            var items = self.queryItems
            
            if let index = items.firstIndex(where: {$0.name == "pending"}) {
                items[index].value = String(pending)
            } else {
                let queryItem = URLQueryItem(name: "pending", value: String(pending))
                items.append(queryItem)
            }
            
            return QueryParam(queryItems: items)
        }
    }
}
