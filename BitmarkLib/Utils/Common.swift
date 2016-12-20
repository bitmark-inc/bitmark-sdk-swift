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
}
