//
//  AssetQuery.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 9/24/18.
//  Copyright © 2018 Bitmark. All rights reserved.
//

import Foundation

public extension Asset {
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
        
        public func registeredBy(registrant: String) -> QueryParam {
            let queryItem = URLQueryItem(name: "registrant", value: registrant)
            var items = self.queryItems
            items.append(queryItem)
            return QueryParam(queryItems: items)
        }
        
        public func assetIds(_ assetIds: [String]) -> QueryParam {
            var items = self.queryItems
            assetIds.forEach { assetId in
                let queryItem = URLQueryItem(name: "asset_ids", value: assetId)
                items.append(queryItem)
            }
            
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
    }
}
