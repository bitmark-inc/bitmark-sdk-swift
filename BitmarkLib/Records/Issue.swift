//
//  Issue.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/23/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import CryptoSwift
import BigInt

public struct Issue {
    
    private(set) var asset: Asset?
    private(set) var nonce: BigUInt?
    private(set) var signature: Data?
    private(set) var isSigned = false
    private(set) var txId: String?
    private(set) var owner: Address?
    
    // MARK:- Internal methods
    
    internal mutating func resetSignState() {
        self.txId = nil
        self.isSigned = false
    }
    
    internal func packRecord() -> Data {
        var txData: Data
        txData = VarInt.encode(value: Config.IssueConfig.value)
        txData = BinaryPacking.append(toData: txData, withData: self.asset?.id?.hexDecodedData)
        txData = BinaryPacking.append(toData: txData, withData: self.owner?.pack())
        
        if let nonce = self.nonce {
            return txData + VarInt.encode(value: nonce)
        }
        else {
            return txData
        }
    }
    
    // MARK:- Public methods
    
    public init() {}
    
    public mutating func set(asset: Asset) {
        self.asset = asset
        resetSignState()
    }
    
    public mutating func set(nonce: Data) {
        self.nonce = VarInt.decode(data: nonce)
        resetSignState()
    }
    
    public mutating func set(nonce: BigUInt) {
        self.nonce = nonce
        resetSignState()
    }
    
    public mutating func sign(privateKey: PrivateKey) throws {
        if self.asset == nil {
            throw(BMError("Issue error: missing asset"))
        }
        if self.nonce == nil {
            throw(BMError("Issue error: missing nonce"))
        }
        
        self.owner = privateKey.address
        
        var recordPacked = packRecord()
        do {
            self.signature = try Ed25519.getSignature(message: recordPacked, privateKey: privateKey.privateKey)
            self.isSigned = true
            
            recordPacked = BinaryPacking.append(toData: recordPacked, withData: self.signature)
            self.txId = recordPacked.sha3(.sha256).hexEncodedString
        }
        catch {
            resetSignState()
        }
    }
}

extension Issue: RPCTransformable {
    public func getRPCParam() throws -> [String : Any] {
        if !self.isSigned {
            throw(BMError("Issue error: need to sign the record before getting RPC param"))
        }
        
        return ["owner": self.owner!.string,
                "signature": self.signature!.toHexString(),
                "asset": self.asset!.id!,
                "nonce": self.nonce!.toIntMax()]
    }
}
