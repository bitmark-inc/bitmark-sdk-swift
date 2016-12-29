//
//  Common.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/16/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation
import BigInt

class Common {
    static func getKey(byValue value: BigUInt) -> KeyType? {
        
        for keyType in Config.keyTypes {
            if BigUInt(keyType.value) == value {
                return keyType
            }
        }
        
        return nil
    }
    
    static func getNetwork(byAddressValue value: BigUInt) -> Network? {
        
        for network in Config.networks {
            if BigUInt(network.addressValue) == value {
                return network
            }
        }
        
        return nil
    }
    
    static func getMostAppearedValue(nodeResults: [NodeResult], keys: [String]? = nil) -> NodeResult {
        
        let error = nodeResults.map { (nodeResult) -> String? in    // Get error field only
                return nodeResult.error
        }
        .map { (error) -> String in                                 // Convert nil to "nil" for easily hashing
            if error == nil {
                return "nil"
            }
            else {
                return error!
            }
        }
        .mode                                                       // Get most appreared error
        
        if let errorMode = error {
            if errorMode == "nil" {
                // No error, continue with results
                // Filter nil
                let results = nodeResults.filter({ (nodeResult) -> Bool in
                    return nodeResult.result != nil
                })
                    .map { (nodeResult) -> [String: Any] in
                    return nodeResult.result!
                }
                
                // O(n*n)
                var result = [String: Any]()
                if let keys = keys {
                    for key in keys {
                        let data = getMostAppearedValue(dataSet: results, key: key)
                        result[key] = data
                    }
                }
                else {
                    result = getMostAppearedValue(dataSet: results)
                }
                
                return NodeResult(result: result, error: nil)
                
            }
            else {
                // If there is error, return error without result
                return NodeResult(result: nil, error: errorMode)
            }
        }
        
        // There are many difference errors returned, something to be wrong ...
        return NodeResult(result: nil, error: nil)
    }
    
    static func getMostAppearedValue(dataSet: [[String: Any]], key: String) -> Any {
        var valueCount = [String: Int]()
        var finalValueString: String? = nil
        var resultValue: Any? = nil
        
        for item in dataSet {
            let value = item[key]
            let valueString = value.debugDescription
            valueCount[valueString] = (valueCount[valueString] ?? 0) + 1
            
            if let finalValueStringUnwrap = finalValueString,
                (valueCount[valueString] ?? 0) > (valueCount[finalValueStringUnwrap] ?? 0) {
                finalValueString = valueString
                resultValue = value
            }
            else {
                finalValueString = valueString
                resultValue = value
            }
        }
        
        return resultValue!                 // Always not nil because we have two above case assigning value to resultValue
    }
    
    static func getMostAppearedValue(dataSet: [[String: Any]]) -> [String: Any] {
        var valueCount = [String: Int]()
        var finalValueString: String? = nil
        var resultValue: [String: Any]? = nil
        
        for item in dataSet {
            let valueString = item.debugDescription
            valueCount[valueString] = (valueCount[valueString] ?? 0) + 1
            
            if let finalValueStringUnwrap = finalValueString,
                (valueCount[valueString] ?? 0) > (valueCount[finalValueStringUnwrap] ?? 0) {
                finalValueString = valueString
                resultValue = item
            }
            else {
                finalValueString = valueString
                resultValue = item
            }
        }
        
        return resultValue!                 // Always not nil because we have two above case assigning value to resultValue
    }
}
