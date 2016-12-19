//
//  BigInt+Extension.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/19/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import BigInt

extension BigUInt {
    var buffer: [UInt8] {
        return [UInt8](self.serialize())
    }
}
