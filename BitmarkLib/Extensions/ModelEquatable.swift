//
//  ModelEquatable.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/21/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

extension KeyType: Equatable {
    public static func ==(lhs: KeyType, rhs: KeyType) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Network: Equatable {
    public static func ==(lhs: Network, rhs: Network) -> Bool {
        return lhs.addressValue == rhs.addressValue
    }
}

extension Address: Equatable {
    public static func ==(lhs: Address, rhs: Address) -> Bool {
        return lhs.pubKey == rhs.pubKey && lhs.network == rhs.network && lhs.string == rhs.string
    }
}
