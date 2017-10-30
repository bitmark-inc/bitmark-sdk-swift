//
//  FileUtil.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/11/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation
import CryptoSwift
import TweetNacl

public struct FileUtil {
    public enum FileUtilError: Error {
        case randomFailed
        case openFileFailed
        case sha3ChunkFailed
    }
    
    public struct Fingerprint {
        public static func computeFingerprint(data: Data) -> String {
            let sha3 = SHA3(variant: .sha512)
            let sha3Data = sha3.calculate(for: [UInt8](data))
            return "01" + Data(bytes: sha3Data).hexEncodedString
        }
        
        public static func computeFingerprint(fromFile url: URL) throws -> String {
            let data = try Data(contentsOf: url)
            return computeFingerprint(data: data)
        }
        
//        public static func computeFingerprint(withChunkFromFilePath url: URL, chunkSize: Int = 1024) throws -> String {
//            var sha3 = SHA3(variant: .sha512)
//            let fileHandler = try FileHandle(forReadingFrom: url)
//
//            var sha3Bytes = [UInt8]()
//
//            var shouldContinue = true
//
//            while shouldContinue {
//                let chunkData = fileHandler.readData(ofLength: chunkSize)
//                if chunkData.count < chunkSize {
//                    shouldContinue = false
//                }
//
//                sha3Bytes += try sha3.update(withBytes: [UInt8](chunkData))
//            }
//
//            sha3Bytes += try sha3.finish()
//            return "01" + Data(bytes: sha3Bytes).hexEncodedString
//        }
    }
    
    public struct Encryption {
        public static func encryptFile(fromFile url: URL, sessionKey: Data, secretKey: Data) throws -> Data {
            let fileContent = try Data(contentsOf: url)
            
            let nonce = Common.randomBytes(length: 12)
            
            let cipher = try ChaCha20(key: [UInt8](sessionKey), iv: [UInt8](nonce))
            
            let encryptedBytes = try cipher.encrypt([UInt8](fileContent))
            var encryptedData = Data(bytes: encryptedBytes)
            
            let signature = try TweetNacl.NaclSign.signDetached(message: fileContent, secretKey: secretKey)
            encryptedData += signature
            
            return encryptedData
        }
    }
    
    public struct Upload {
        public static func multipartUpload(data: Data, toURL url: URL, otherParams: [String: String]?, completionHandler: (() -> Void)?) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        
        private static func createBody(parameters: [String: String]?,
                                       boundary: String,
                                       data: Data,
                                       mimeType: String,
                                       filename: String) -> Data {
            var body = Data()
            
            let boundaryPrefix = "--\(boundary)\r\n"
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    body.append(string: boundaryPrefix)
                    body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.append(string: "\(value)\r\n")
                }
            }
            
            body.append(string: boundaryPrefix)
            body.append(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
            body.append(string: "Content-Type: \(mimeType)\r\n\r\n")
            body.append(data)
            body.append(string: "\r\n")
            body.append(string: "--".appending(boundary.appending("--")))
            
            return body as Data
        }
    }
}

fileprivate extension Data {
    fileprivate mutating func append(string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
