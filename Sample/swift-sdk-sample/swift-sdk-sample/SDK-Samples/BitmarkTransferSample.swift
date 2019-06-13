//
//  BitmarkTransferSample.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/17.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK

class BitmarkTransferSample {
    public static func transferOneSignature(sender: Account, bitmarkId: String, receiverAccountNumber: String) throws -> String {
        var transferParams = try Bitmark.newTransferParams(to: receiverAccountNumber)
        try transferParams.from(bitmarkID: bitmarkId)
        try transferParams.sign(sender)
        let txId = try Bitmark.transfer(withTransferParams: transferParams)
        
        return txId
    }
    
    public static func sendTransferOffer(sender: Account, bitmarkId: String, receiverAccountNumber: String) throws {
        var offerParam = try Bitmark.newOfferParams(to: receiverAccountNumber, info: nil)
        try offerParam.from(bitmarkID: bitmarkId)
        try offerParam.sign(sender)
        
        try Bitmark.offer(withOfferParams: offerParam)
    }
    
    public static func acceptTransferOffer(receiver: Account, bitmarkId: String) throws {
        return try respondTransferOffer(account: receiver, bitmarkId: bitmarkId, action: .accept)
    }
    
    public static func rejectTransferOffer(receiver: Account, bitmarkId: String) throws {
        return try respondTransferOffer(account: receiver, bitmarkId: bitmarkId, action: .reject)
    }
    
    private static func respondTransferOffer(account: Account, bitmarkId: String, action: CountersignedTransferAction) throws {
        let bitmark = try Bitmark.get(bitmarkID: bitmarkId)
        var responseOfferParam = try Bitmark.newTransferResponseParams(withBitmark: bitmark, action: action)
        try responseOfferParam.sign(account)
        
        try Bitmark.respond(withResponseParams: responseOfferParam)
    }
}
