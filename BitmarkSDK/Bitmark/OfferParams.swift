//
//  OfferParams.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 9/24/18.
//  Copyright © 2018 Bitmark. All rights reserved.
//

import Foundation

public struct Offer {
    var transfer: TransferRequest
    let extraInfo: [String: Any]?
}

extension Offer: Parameterizable {
    mutating func sign(_ signable: KeypairSignable) throws {
        try self.transfer.sign(signable)
    }
    
    public func toJSON() throws -> [String : Any] {
        if let extraInfo = self.extraInfo {
            return ["record": try self.transfer.toJSON(),
                    "extra_info": extraInfo]
        } else {
            return ["record": try self.transfer.toJSON()]
        }
    }
}

public struct OfferParams {
    var offer: Offer
    
    public mutating func from(bitmarkID: String) throws {
        let api = API()
        guard let bitmarkInfo = try api.bitmarkInfo(bitmarkId: bitmarkID) else {
            throw("Cannot get bitmark info")
        }
        self.offer.transfer.set(fromTx: bitmarkInfo.headId)
    }
}

extension OfferParams: Parameterizable {
    mutating func sign(_ signable: KeypairSignable) throws {
        try self.offer.sign(signable)
    }
    
    public func toJSON() throws -> [String : Any] {
        return ["offer": try offer.toJSON()]
    }
}

public enum CountersignedTransferAction: String {
    case accept = "accept"
    case reject = "reject"
}

public struct CountersignedTransferRequest: Codable {
    let link: String
    let owner: String
    let signature: String
    let counterSignature: String
}

public struct OfferResponseParam {
    let id: String
    let action: CountersignedTransferAction
    let record: CountersignedTransferRecord
    var counterSignature: String
}

extension OfferResponseParam: Parameterizable {
    
}
