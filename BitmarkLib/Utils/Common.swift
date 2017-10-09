//
//  Common.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/16/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public class Common {
    static func getKey(byValue value: UInt64) -> KeyType? {
        
        for keyType in Config.keyTypes {
            if keyType.value == value {
                return keyType
            }
        }
        
        return nil
    }
    
    static func getNetwork(byAddressValue value: UInt64) -> Network? {
        
        for network in Config.networks {
            if network.addressValue == value {
                return network
            }
        }
        
        return nil
    }
    
    static func increaseOne(baseLength: Int, data: Data) -> Data {
        var buffer = [UInt8](data)
        
        var value: UInt8 = 0
        
        for i in baseLength..<buffer.count {
            let j = buffer.count - i - 1 + baseLength
            value = buffer[j]
            
            if value == 0xff {
                buffer[j] = 0x00
            }
            else {
                buffer[j] = value + 1
                return Data(bytes: buffer)
            }
        }
        
        buffer.append(0x01)
        
        return Data(bytes: buffer)
    }
    
    public static func findNonce(base: Data, difficulty: Data) -> Data {
        let nonce = UInt64("8000000000000000", radix: 16)!
        var combine = base + Data(bytes: nonce.toUInt8s)
        let baseLength = base.count
        
        var notFoundYet = true
        var count = 0
        
        while notFoundYet {
            combine = increaseOne(baseLength: baseLength, data: combine)
            let hash = combine.sha3(.sha256)
            let hashBN = hash.toUInt64
            let difficultyBN = difficulty.toUInt64
            
            if hashBN < difficultyBN {
                notFoundYet = false
            }
            
            count += 1
            print("trying ... \(count)")
        }
        
        return combine.slice(start: baseLength, end: combine.count)
    }
}
