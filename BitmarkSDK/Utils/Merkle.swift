//
//  Merkle.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 3/30/20.
//  Copyright © 2020 Bitmark. All rights reserved.
//

import Foundation

class MerkleTree {
    
    class func buildTree(with txIDs: [Data], combineFunc: (Data, Data) -> Data) -> [Data] {
        // compute length if ids + all tree levels including root
        let idCount = txIDs.count
        
        var totalLength = 1 // all ids + space for the final root
        
        var n = idCount
        while n > 1 {
            totalLength += n
            n = (n + 1) / 2
        }
        
        // add initial ids
        var tree = [Data](repeating: Data(), count: totalLength)
        
        // copy txid to tree
        for i in txIDs.indices {
            tree[i] = txIDs[i]
        }
        
        n = idCount
        var j = 0
        var workLength = idCount
        
        while workLength > 1 {
            for i in stride(from: 0, to: workLength, by: 2) {
                var k = j + 1
                if i + 1 == workLength {
                    k = j
                }
                
                tree[n] = combineFunc(tree[j],tree[k])
                n += 1
                j = k + 1
            }
            
            workLength = (workLength + 1) / 2
        }
        
        return tree
    }
}
