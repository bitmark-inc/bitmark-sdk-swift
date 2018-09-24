//
//  Asset.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/22/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

public struct RegistrationParams {
    
    internal(set) public var id: String?
    var name: String?
    var fingerprint: String?
    var metadata = ""
    var registrant: AccountNumber?
    var signature: Data?
    var isSigned = false
    
    static let metadataSeparator = "\u{0000}"
    
    // MARK:- Static methods
    
    static func convertString(fromMetadata metadata: [String: String]) -> String {
        let tmp = metadata.reduce([]) { (result, keyvalue) -> [String] in
            var newResult = result
            newResult.append(keyvalue.key)
            newResult.append(keyvalue.value)
            return newResult
        }
        
        return tmp.joined(separator: metadataSeparator)
    }
    
    static func convertMetadata(fromString string: String) throws -> [String: String] {
        let tmp = string.components(separatedBy: metadataSeparator)
        if tmp.count % 2 != 0 {
            throw(BMError("can not parse string to metadata"))
        }
        
        var result = [String: String]()
        let count = tmp.count / 2
        for i in 0..<count {
            let key = tmp[i * 2]
            let value = tmp[i * 2 + 1]
            result[key] = value
        }
        
        return result
    }
    
    static func isValidLength(metadata: String) -> Bool {
        return metadata.utf8.count <= Config.AssetConfig.maxMetadata
    }
    
    // MARK:- Internal methods
    
    internal mutating func resetSignState() {
        self.isSigned = false
    }
    
    internal func computeAssetId(fingerprint: String?) -> String? {
        guard let fingerprintData = fingerprint?.data(using: .utf8) else {
            return nil
        }
        return fingerprintData.sha3(.sha512).hexEncodedString
    }
    
    internal func packRecord() throws -> Data {
        var txData: Data
        txData = Data.varintFrom(Config.AssetConfig.value)
        txData = BinaryPacking.append(toData: txData, withString: self.name)
        txData = BinaryPacking.append(toData: txData, withString: self.fingerprint)
        txData = BinaryPacking.append(toData: txData, withString: self.metadata)
        txData = BinaryPacking.append(toData: txData, withData: try self.registrant?.pack())
        
        return txData
    }
    
    internal mutating func set(metadata: [String: String]) throws {
        let metaDataString = RegistrationParams.convertString(fromMetadata: metadata)
        if !RegistrationParams.isValidLength(metadata: metaDataString) {
            throw(BMError("meta data's length must be in correct length"))
        }
        self.metadata = metaDataString
        resetSignState()
    }
    
    internal mutating func set(fingerPrint: String) throws {
        if !(fingerPrint.count <= Config.AssetConfig.maxFingerprint) {
            throw(BMError("fingerprint's length must be in correct length"))
        }
        self.fingerprint = fingerPrint
        self.id = computeAssetId(fingerprint: fingerPrint)
        resetSignState()
    }
    
    internal mutating func set(name: String) throws {
        if !(name.count <= Config.AssetConfig.maxName) {
            throw(BMError("name's length must be in corrent length"))
        }
        self.name = name
        resetSignState()
    }
    
    internal mutating func set(metadata: String) throws {
        let meta = try RegistrationParams.convertMetadata(fromString: metadata)
        try set(metadata: meta)
    }
    
    // MARK:- Public methods
    
    public init() {}
    
    public mutating func setFingerprint(fromFileURL fileURL: String) throws -> String {
        let fileData = try Data(contentsOf: URL(fileURLWithPath: fileURL))
        return FileUtil.computeFingerprint(data: fileData)
    }
}

extension RegistrationParams: Parameterizable {
    mutating func sign(_ signable: KeypairSignable) throws {
        if self.name == nil {
            throw(BMError("Asset error: missing name"))
        }
        if self.fingerprint == nil {
            throw(BMError("Asset error: missing fingerprint"))
        }
        self.registrant =  AccountNumber.build(fromPubKey: signable.publicKey)
        self.signature = try signable.sign(message: try self.packRecord())
        guard let id = computeAssetId(fingerprint: self.fingerprint) else {
            resetSignState()
            return
        }
        self.id = id
        self.isSigned = true
    }
    
    func toJSON() throws -> [String : Any] {
        if !self.isSigned {
            throw(BMError("Asset error: need to sign the record before getting RPC message"))
        }
        
        guard let fingerprint = fingerprint,
            let name = name,
            let registrant = registrant,
            let signature = signature
            else {
                throw(BMError("Asset error: some fields are missing"))
        }
        
        return ["metadata": metadata,
                "name": name,
                "fingerprint": fingerprint,
                "registrant": registrant,
                "signature": signature.hexEncodedString]
    }
}
