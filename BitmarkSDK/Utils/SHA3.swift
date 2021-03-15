//
//  SHA3.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/5/18.
//  Copyright © 2018 Bitmark. All rights reserved.
//

import Foundation
import tinysha3

struct SHA3Compute {
    static func computeSHA3(data: Data, length: Int) -> Data {
        let byteLength = length / 8
        var output = Data(count: byteLength)
        
        output.withUnsafeMutableBytes({ (outputPointer: UnsafeMutablePointer<UInt8>) -> Void in
            return data.withUnsafeBytes({ (dataPointer: UnsafePointer<UInt8>) -> Void in
                sha3(dataPointer, data.count, outputPointer, Int32(byteLength))
            })
        })
        
        return output
    }
    
    static func computeSHAKE256(data: Data, repeatCount: Int, length: Int, count: Int) -> Data {
        var output = Data(count: length * count)
        
        output.withUnsafeMutableBytes({ (outputPointer: UnsafeMutablePointer<UInt8>) -> Void in
            return data.withUnsafeBytes({ (dataPointer: UnsafePointer<UInt8>) -> Void in
                shake256(dataPointer, Int32(repeatCount), data.count, outputPointer, Int32(length), Int32(count))
            })
        })
        
        return output
    }
  
    static func computeSHA3FromURL(fileURL: URL, length: Int) throws -> Data {
        let byteLength = length / 8
      
        let blockSize = 1024
        
        guard let inputStream = InputStream(url: fileURL) else {
          throw("Cannot read the file at " + fileURL.absoluteString)
        }
        
        var ctx = sha3_ctx_t()
        withUnsafeMutablePointer(to: &ctx) { (ctxPointer) in
            return sha3_init(ctxPointer, Int32(byteLength))
        }
        
        var inputBuffer = [UInt8](repeating: 0, count: blockSize)
        inputStream.open()
        defer {
            inputStream.close()
        }
        
        while true {
            let length = inputStream.read(&inputBuffer, maxLength: blockSize)
            if length == 0 {
                // EOF
                break
            }
            else if length < 0 {
                throw("Cannot read the file at " + fileURL.absoluteString)
            }
            
            let dataBlock = Data(bytes: inputBuffer, count: length)
            
            dataBlock.withUnsafeBytes { (dataPointer) -> Void in
                withUnsafeMutablePointer(to: &ctx) { (ctxPointer) in
                  return sha3_update(ctxPointer, dataPointer, dataBlock.count)
                }
            }
        }
      
        var output = Data(count: byteLength)
        output.withUnsafeMutableBytes { (outputPointer: UnsafeMutablePointer<UInt8>) -> Void in
            withUnsafeMutablePointer(to: &ctx) { (ctxPointer) -> Void in
                sha3_final(outputPointer, ctxPointer)
            }
        }
        
        return output
    }
}

public extension Data {
    func sha3(length: Int) -> Data {
        return SHA3Compute.computeSHA3(data: self, length: length)
    }
}

public extension URL {
    func sha3(length: Int) throws -> Data {
        return try SHA3Compute.computeSHA3FromURL(fileURL: self, length: length)
    }
}
