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
    var attribute: (key: String, value: String)? {
        let components = contents.characters.split(separator: "=", maxSplits: 1)
        guard components.count == 2 else { return nil }
        return (key: String(components[0]), value: String(components[1]))
    }
}

extension TXTRecord {
    static func parse(attributes records: [TXTRecord]) throws -> [String : String] {
        var result: [String : String] = [:]
        for record in records {
            guard let (key, value) = record.attribute else {
                throw(BMError("Expected RFC 1464 format.", type: .system))
            }
            result[key] = value
        }
        return result
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
