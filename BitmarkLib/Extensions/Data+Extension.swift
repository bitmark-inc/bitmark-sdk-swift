//
//  Data+Extension.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/19/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

extension Data {
    mutating func concat(data: Data) {
        let buffer1 = [UInt8](self)
        let buffer2 = [UInt8](data)
        let buffer = buffer1 + buffer2
        self = Data(bytes: buffer)
    }
    
    func concating(data: Data) -> Data {
        let buffer1 = [UInt8](self)
        let buffer2 = [UInt8](data)
        let buffer = buffer1 + buffer2
        return Data(bytes: buffer)
    }
    
    static func +(data1: Data, data2: Data) -> Data {
        return data1.concating(data: data2)
    }
}
