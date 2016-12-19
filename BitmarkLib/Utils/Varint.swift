import Foundation
import BigInt

class VarInt {
    
    public static func varintDecode(data: Data) -> BigUInt {
        let encodedBuffer = [UInt8](data)
        var currentByte: UInt8 = 0x00
        var result = BigUInt(0)
        let maxLength = encodedBuffer.count > 9 ? 9 : encodedBuffer.count
        
        var i = 0
        var currentValue: UInt8 = 0
        
        while i < maxLength && (currentByte & 0x80) == 0x80 {
            currentByte = encodedBuffer[i]
            currentValue = encodedBuffer[i]
            
            if i < 8 {
                currentValue = currentValue * 0x7f
            }
            
            var currentValueBig = BigUInt(currentValue)
            currentValueBig = currentValueBig << (i * 7)
            
            result.add(currentValueBig)
            
            i += 1
        }
        
        return result
    }
    
    public static func varintEncode(value: BigUInt) -> Data {
        var result = [UInt8](repeating: 0, count: 9)
        var offsetCount = 0
        var valueBuffer: [UInt8]
        let valueCompared = BigUInt(128)
        var valueClone = value
        
        while valueClone >= valueCompared {
            valueBuffer = value.buffer
            let lastByte = valueBuffer[valueBuffer.count - 1] | 0x80
            result[offsetCount] = lastByte
            valueClone = valueClone >> 7
            offsetCount += 1
        }
        
        if offsetCount == 9 {
            result[8] = result[8] | 0x80
            offsetCount = 0
        } else {
            result[offsetCount] = UInt8(value.toIntMax())
        }
        
        return Data(bytes: result).subdata(in: 0..<offsetCount+1)
    }
}
