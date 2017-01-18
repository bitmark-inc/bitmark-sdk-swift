//
//  Data+Extension.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/19/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public extension Data {
    public mutating func concat(data: Data) {
        let buffer1 = [UInt8](self)
        let buffer2 = [UInt8](data)
        let buffer = buffer1 + buffer2
        self = Data(bytes: buffer)
    }
    
    public func concating(data: Data) -> Data {
        let buffer1 = [UInt8](self)
        let buffer2 = [UInt8](data)
        let buffer = buffer1 + buffer2
        return Data(bytes: buffer)
    }
    
    public func slice(start: Int, end: Int) -> Data {
        let trueEnd = Swift.min(end, self.count)
        return self.subdata(in: start..<trueEnd)
    }
    
    public static func +(data1: Data, data2: Data) -> Data {
        return data1.concating(data: data2)
    }
    
    public static func +=(data1: inout Data, data2: Data) {
        data1.concat(data: data2)
    }
    
    // NSData bridging
    public var nsdata: NSData {
        return NSData(data: self)
    }
    
    // Hex string
    public var hexEncodedString: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}

public extension String {
    public var hexDecodedData: Data {
        var hex = self
        var data = Data()
        while(hex.characters.count > 0) {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
}
