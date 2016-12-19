import Foundation

class VarInt {
    enum VarIntError : Error {
        case inputStreamRead
        case overflow
    }
    
    public static func encodeUVarInt(value: UInt64) -> Data {
        return Data(bytes: putUVarInt(value))
    }
    
    public static func decodeUVarInt(data: Data) -> UInt64 {
        let buffer = [UInt8](data)
        let result = uVarInt(buffer)
        return result.0
    }
    
    public static func encodeVarInt(value: Int64) -> Data {
        return Data(bytes: putVarInt(value))
    }
    
    public static func decodeVarInt(data: Data) -> Int64 {
        let buffer = [UInt8](data)
        let result = varInt(buffer)
        return result.0
    }
    
    /** putVarInt encodes a UInt64 into a buffer and returns it.
     */
    public static func putUVarInt(_ value: UInt64) -> [UInt8] {
        var buffer = [UInt8]()
        var val: UInt64 = value
        
        while val >= 0x80 {
            buffer.append((UInt8(truncatingBitPattern: val) | 0x80))
            val >>= 7
        }
        
        buffer.append(UInt8(val))
        return buffer
    }
    
    /** uVarInt decodes an UInt64 from a byte buffer and returns the value and the
     number of bytes greater than 0 that were read.
     If an error occurs the value will be 0 and the number of bytes n is <= 0
     with the following meaning:
     n == 0: buf too small
     n  < 0: value larger than 64 bits (overflow)
     and -n is the number of bytes read
     */
    public static func uVarInt(_ buffer: [UInt8]) -> (UInt64, Int) {
        
        var output: UInt64 = 0
        var counter = 0
        var shifter:UInt64 = 0
        
        for byte in buffer {
            if byte < 0x80 {
                if counter > 9 || counter == 9 && byte > 1 {
                    return (0,-(counter+1))
                }
                return (output | UInt64(byte)<<shifter, counter+1)
            }
            
            output |= UInt64(byte & 0x7f)<<shifter
            shifter += 7
            counter += 1
        }
        return (0,0)
    }
    
    /** putVarInt encodes an Int64 into a buffer and returns it.
     */
    public static func putVarInt(_ value: Int64) -> [UInt8] {
        
        var unsignedValue = UInt64(value) << 1
        
        if unsignedValue < 0 {
            unsignedValue = ~unsignedValue
        }
        
        return putUVarInt(unsignedValue)
    }
    
    /** varInt decodes an Int64 from a byte buffer and returns the value and the
     number of bytes greater than 0 that were read.
     If an error occurs the value will be 0 and the number of bytes n is <= 0
     with the following meaning:
     n == 0: buf too small
     n  < 0: value larger than 64 bits (overflow)
     and -n is the number of bytes read
     */
    public static func varInt(_ buffer: [UInt8]) -> (Int64, Int) {
        
        let (unsignedValue, bytesRead)  = uVarInt(buffer)
        var value                       = Int64(unsignedValue >> 1)
        
        if unsignedValue & 1 != 0 { value = ~value }
        
        return (value, bytesRead)
    }
    
    
    /** readUVarInt reads an encoded unsigned integer from the reader and returns
     it as an UInt64 */
    public static func readUVarInt(_ reader: InputStream) throws -> UInt64 {
        
        var value: UInt64   = 0
        var shifter: UInt64 = 0
        var index = 0
        
        repeat {
            var buffer = [UInt8](repeating: 0, count: 10)
            
            if reader.read(&buffer, maxLength: 1) < 0 {
                throw VarIntError.inputStreamRead
            }
            
            let buf = buffer[0]
            
            if buf < 0x80 {
                if index > 9 || index == 9 && buf > 1 {
                    throw VarIntError.overflow
                }
                return value | UInt64(buf) << shifter
            }
            value |= UInt64(buf & 0x7f) << shifter
            shifter += 7
            index += 1
        } while true
    }
    
    /** readVarInt reads an encoded signed integer from the reader and returns
     it as an Int64 */
    public static func readVarInt(_ reader: InputStream) throws -> Int64 {
        
        let unsignedValue = try readUVarInt(reader)
        var value = Int64(unsignedValue >> 1)
        
        if unsignedValue & 1 != 0 {
            value = ~value
        }
        
        return value
    }
}
