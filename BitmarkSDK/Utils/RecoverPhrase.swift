//
//  RecoverPhrase.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/23/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation
import BIP39

public enum RecoveryLanguage {
    case english
    case chineseTraditional
}

public struct RecoverPhrase {
    
    public enum RecoverPhraseError: Error {
        case invalidLength
        case wordNotFound
        case invalid
    }
    

    
    internal static let masks: [UInt64] = [0, 1, 3, 7, 15, 31, 63, 127, 255, 511, 1023]
    
    public struct V1 {
        public static func createPhrase(fromData data: Data, language: RecoveryLanguage) throws -> [String] {
            if data.count != 33 {
                throw(RecoverPhraseError.invalidLength)
            }
            
            let input = [UInt8](data)
            var phrases = [String]()
            var accumulator: UInt64 = 0
            var bits: UInt64 = 0
            
            for i in 0..<33 {
                accumulator = accumulator << 8 + UInt64(input[i])
                bits += 8
                
                if bits >= 11 {
                    bits -= 11 // [ 11 bits] [offset bits]

                    let index = accumulator >> bits
                    accumulator &= masks[Int(bits)]
                    let word = bip39Word(index: Int(index), language: language)
                    
                    phrases.append(word)
                }
            }
            
            if phrases.count != 24 {
                throw(RecoverPhraseError.invalidLength)
            }
            
            return phrases
        }
        
        public static func recoverSeed(fromPhrase phrases:[String], language: RecoveryLanguage) throws -> Data {
            if phrases.count != 24 {
                throw RecoverPhraseError.invalidLength
            }
            
            var dataBytes = [UInt8]()
            
            var remainer: UInt64 = 0
            var bits: UInt64 = 0
            
            for i in 0..<phrases.count {
                let word = phrases[i]
                guard let n = indexOfWord(word, language: language) else {
                    throw(RecoverPhraseError.wordNotFound)
                }
                
                remainer = (remainer << 11) + UInt64(n)
                
                bits += 11
                repeat {
                    let a = 0xff & (remainer >> (bits - 8))
                    dataBytes.append(UInt8(truncatingIfNeeded: a))
                    bits -= 8
                } while (bits >= 8)
                
                remainer &= masks[Int(bits)]
            }
            
            return Data(bytes: dataBytes)
        }
    }

    public struct V2 {

        public static func createPhrase(fromData data: Data, language: RecoveryLanguage) throws -> [String] {
            if data.count != Config.SeedConfigV2.seedLength {
                throw(RecoverPhraseError.invalidLength)
            }

            // this ensures last nibble is zeroed
            if 0 != data[16] & 0x0f {
                throw(RecoverPhraseError.invalidLength)
            }

            let newContext = BIP39NewContext()
            newContext.clear()

            var dataBytes: [UInt8] = []
            data.withUnsafeBytes {
                dataBytes.append(contentsOf: $0)
            }

            newContext.setBytes(dataBytes, length: dataBytes.count)
            newContext.setByteCount(count: dataBytes.count)
            newContext.appendChecksum()

            let phrases = (0..<newContext.wordCount).map { (index) -> String in
                let word = newContext.getWord(in: index)
                return BIP39Util.mnemonicFromWord(word)
            }

            guard phrases.count == 13 else {
                throw RecoverPhraseError.invalidLength
            }

            return phrases
        }

        public static func recoverSeed(fromPhrase phrases:[String], language: RecoveryLanguage) throws -> Data {

            // Common BIP39
            if phrases.count == 13 {
                if let seed = BIP39Util.secretFromMnemonics(phrases) {
                    return seed
                } else {
                    throw RecoverPhraseError.invalid
                }
            }

            // Old Phrases
            if phrases.count != 12 {
                throw RecoverPhraseError.invalidLength
            }

            let bip39NewContext = BIP39NewContext()
            bip39NewContext.clear()
            bip39NewContext.setByteCount(count: Config.SeedConfigV2.seedLength)

            for (index, mnemonic) in phrases.enumerated() {
                let word = BIP39Util.wordFromMnemonic(mnemonic)
                bip39NewContext.setWord(word, in: index)
            }

            //--------------------------------------------------
            // add checksum to valid seed
            //--------------------------------------------------

            guard !bip39NewContext.verifyChecksum() else {
                throw "unexpected pre-verified..."
            }

            bip39NewContext.appendChecksum()
            if bip39NewContext.verifyChecksum() {

            } else {
                throw RecoverPhraseError.invalid
            }

            let dataBytes = bip39NewContext.getBytes()
            return Data(bytes: dataBytes, count: Config.SeedConfigV2.seedLength)
        }
    }
}
