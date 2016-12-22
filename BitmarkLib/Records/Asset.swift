//
//  Asset.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/22/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import CryptoSwift

public struct RPCParam {
    public let metadata: String
    public let name: String
    public let fingerprint: String
    public let registrant: String
    public let signature: String
}

public struct Asset {
    
    private(set) var id: String?
    private(set) var name: String?
    private(set) var fingerprint: String?
    private(set) var metadata: String?
    private(set) var registrant: Address?
    private(set) var signature: Data?
    private(set) var isSigned = false
    
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
    
    static func convertMetadata(fromString string: String) -> [String: String] {
        let tmp = string.components(separatedBy: metadataSeparator)
        precondition(tmp.count % 2 == 0, "can not parse string to metadata")
        
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
        return metadata.characters.count <= Config.AssetConfig.maxMetadata
    }
    
    // MARK:- Internal methods
    
    internal mutating func resetSignState() {
        self.id = nil
        self.isSigned = false
    }
    
    internal func computeAssetId(fingerprint: String?) -> String? {
        guard let fingerprintData = fingerprint?.data(using: .utf8) else {
            return nil
        }
        return fingerprintData.sha3(.sha512).hexEncodedString
    }
    
    // MARK:- Public methods
    
    public func packRecord() -> Data {
        var txData: Data
        txData = VarInt.encode(value: Config.AssetConfig.value)
        txData = BinaryPacking.append(toData: txData, withString: self.name)
        txData = BinaryPacking.append(toData: txData, withString: self.fingerprint)
        txData = BinaryPacking.append(toData: txData, withString: self.metadata)
        txData = BinaryPacking.append(toData: txData, withData: self.registrant?.pack())
        
        return txData
    }
    
    public mutating func set(metadata: [String: String]) {
        let metaDataString = Asset.convertString(fromMetadata: metadata)
        precondition(Asset.isValidLength(metadata: metaDataString), "meta data's length must be in correct length")
        self.metadata = metaDataString
        resetSignState()
    }
    
    public mutating func set(fingerPrint: String) {
        precondition(fingerPrint.characters.count <= Config.AssetConfig.maxFingerprint, "fingerprint's length must be in correct length")
        self.fingerprint = fingerPrint
        resetSignState()
    }
    
    public mutating func set(name: String) {
        precondition(name.characters.count <= Config.AssetConfig.maxName, "name's length must be in corrent length")
        self.name = name
        resetSignState()
    }
    
    public mutating func set(metadata: String) {
        let meta = Asset.convertMetadata(fromString: metadata)
        set(metadata: meta)
    }
    
    public mutating func sign(withPrivateKey privateKey: PrivateKey) {
        precondition(self.name != nil, "Asset error: missing name")
        precondition(self.fingerprint != nil, "Asset error: missing fingerprint")
        
        self.registrant = privateKey.address
        do {
            self.signature = try Ed25519.getSignature(message: self.packRecord(), privateKey: privateKey.privateKey)
            guard let id = computeAssetId(fingerprint: self.fingerprint) else {
                resetSignState()
                return
            }
            self.id = id
            self.isSigned = true
        }
        catch {
            resetSignState()
        }
    }
    
    public func getRPCParam() -> RPCParam {
        precondition(self.isSigned, "Asset error: need to sign the record before getting RPC message")
        
        guard let metadata = metadata,
            let fingerprint = fingerprint,
            let name = name,
            let registrant = registrant,
            let signature = signature
            else {
            precondition(false, "Asset error: some field is missing")
        }
        
        return RPCParam(metadata: metadata,
                        name: name,
                        fingerprint: fingerprint,
                        registrant: registrant.string,
                        signature: signature.hexEncodedString)
    }
}
