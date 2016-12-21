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
