import Foundation
import BigInt

public class VarInt {
    
    public static func decode(data: Data) -> BigUInt {
        var output: UInt64 = 0
        var counter = 0
        var shifter: UInt64 = 0
        let buffer = [UInt8](data)
        
        for byte in buffer {
            if byte < 0x80 {
                if counter >= 9 && byte > 1 {
                    return BigUInt(0)
                }
                
                return BigUInt(output | UInt64(byte) << shifter)
            }
            
            output |= UInt64(byte & 0x7f) << shifter
            shifter += 7
            counter += 1
        }
        
        return BigUInt(0)
    }
    
    public static func encode(value: BigUInt) -> Data {
        var buffer = [UInt8]()
        var val = value
        var offsetCount = 0
        
        while val >= 0x80 {
            buffer.append(UInt8(truncatingBitPattern: val.toIntMax() | 0x80))
            val >>= 7
            offsetCount += 1
        }
        
        // Append last byte
        if offsetCount >= 9 {
            buffer[8] = UInt8(truncatingBitPattern: val.toIntMax() | 0x80)
        }
        else {
            buffer.append(UInt8(truncatingBitPattern: val.toIntMax()))
        }
        
        return Data(bytes: buffer).slice(start: 0, end: (offsetCount + 1))
    }
    
    public static func encode(value: Int) -> Data {
        return encode(value: BigUInt(value))
    }
}
