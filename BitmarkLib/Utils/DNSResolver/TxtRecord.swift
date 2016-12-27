//
//  TxtRecord.swift
//  BitmarkLib
//
//  From https://github.com/JadenGeller/Burrow-Client
//  Ported to Swift 3 by Anh Nguyen on 12/24/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public struct TXTRecord {
    var contents: String
}

extension TXTRecord {
    var keyValue: [String: Any] {
        return contents.components(separatedBy: " ")
        .reduce([String: Any]()) { (result, item) -> [String: Any] in
            var returnResult = result
            let components = item.components(separatedBy: "=")
            if components.count == 2 {
                returnResult[components[0]] = components[1]
            }
            
            return returnResult
        }
    }
}

extension String {
    init?(baseAddress: UnsafePointer<CChar>, length: Int, encoding: String.Encoding) {
        self = String(cString: baseAddress)
    }
}

extension TXTRecord {
    init?(buffer: UnsafeBufferPointer<UInt8>) {
        
        var contents = ""
        var componentIndex = buffer.startIndex
        while componentIndex < buffer.endIndex {
            let componentLength = Int(buffer[componentIndex])
            guard let componentBase = buffer.baseAddress?.advanced(by: componentIndex + 1) else {
                return nil
            }
            
            contents += String(cString: componentBase)
            
            componentIndex += Int(1 + componentLength)
        }
        
        self.init(contents: contents)
    }
}
