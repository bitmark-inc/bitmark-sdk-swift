//
//  Account+Services.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/31/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

public enum TransferOfferAction: String {
    case accept = "accept"
    case reject = "reject"
}

//public extension Account {
//    
//    public func issueBitmarks(assetFile url: URL,
//                              propertyName name: String,
//                              propertyMetadata metadata: [String: String]? = nil,
//                              quantity: Int = 1) throws -> ([Issue], Asset) {
//        let data = try Data(contentsOf: url)
//        let network = self.authKey.network
//        let fingerprint = FileUtil.Fingerprint.computeFingerprint(data: data)
//        var asset = Asset()
//        try asset.set(name: name)
//        try asset.set(fingerPrint: fingerprint)
//        if let metadata = metadata {
//            try asset.set(metadata: metadata)
//        }
//        try asset.sign(withPrivateKey: self.authKey)
//        
//        var issues = [Issue]()
//        for _ in 0..<quantity {
//            var issue = Issue()
//            issue.set(nonce: UInt64(arc4random()))
//            issue.set(asset: asset)
//            try issue.sign(privateKey: self.authKey)
//            issues.append(issue)
//        }
//        
//        let api = API(network: network)
//        
//        let issueSuccess = try api.issue(withIssues: issues, assets: [asset])
//        if !issueSuccess {
//            throw("Fail to issue bitmark")
//        }
//        
//        return (issues, asset)
//    }
//    
//    public func issueBitmarks(fingerprint: String,
//                              propertyName name: String,
//                              propertyMetadata metadata: [String: String]? = nil,
//                              quantity: Int = 1) throws -> ([Issue], Asset) {
//        var asset = Asset()
//        try asset.set(name: name)
//        try asset.set(fingerPrint: fingerprint)
//        if let metadata = metadata {
//            try asset.set(metadata: metadata)
//        }
//        try asset.sign(withPrivateKey: self.authKey)
//        
//        var issues = [Issue]()
//        for _ in 0..<quantity {
//            var issue = Issue()
//            issue.set(nonce: UInt64(arc4random()))
//            issue.set(asset: asset)
//            try issue.sign(privateKey: self.authKey)
//            issues.append(issue)
//        }
//        
//        let network = self.authKey.network
//        let api = API(network: network)
//        let issueSuccess = try api.issue(withIssues: issues, assets: [asset])
//        if !issueSuccess {
//            throw("Fail to issue bitmark")
//        }
//        
//        return (issues, asset)
//    }
//    
//    public func transferBitmark(bitmarkId: String,
//                                toAccount recipient: String) throws -> Bool {
//        
//        let network = self.authKey.network
//        let api = API(network: network)
//        
//        var transfer = Transfer()
//        guard let bitmarkInfo = try api.bitmarkInfo(bitmarkId: bitmarkId) else {
//            throw("Cannot find bitmark with id:" + bitmarkId)
//        }
//        transfer.set(from: bitmarkInfo.headId)
//        try transfer.set(to: try AccountNumber(address: recipient))
//        try transfer.sign(privateKey: self.authKey)
//        
//        return try api.transfer(withData: transfer)
//    }
//    
//    public func createTransferOffer(bitmarkId: String, recipient: String) throws -> TransferOffer {
//        let network = self.authKey.network
//        let api = API(network: network)
//        
//        guard let bitmarkInfo = try api.bitmarkInfo(bitmarkId: bitmarkId) else {
//            throw("Fail to get bitmark info")
//        }
//        
//        var transfer = TransferOffer(txId: bitmarkInfo.headId, receiver: try AccountNumber(address: recipient))
//        try transfer.sign(withSender: self)
//        
//        return transfer;
//    }
//    
//    public func createAndSubmitTransferOffer(bitmarkId: String, recipient: String, extraInfo: [String: Any]? = nil) throws -> String {
//        let network = self.authKey.network
//        let api = API(network: network)
//        
//        let offer = try createTransferOffer(bitmarkId: bitmarkId, recipient: recipient)
//        
//        return try api.submitTransferOffer(withSender: self, offer: offer, extraInfo: extraInfo)
//    }
//    
//    public func cancelTransferOffer(offerId: String) throws -> Bool {
//        let network = self.authKey.network
//        let api = API(network: network)
//        
//        let offer = try api.getTransferOffer(withId: offerId)
//        
//        let counterSign = try createCounterSign(offer: offer)
//        
//        return try api.completeTransferOffer(withAccount: self,
//                                             offerId: offerId,
//                                             action: "cancel",
//                                             counterSignature: counterSign.counterSignature!.hexEncodedString)
//    }
//    
//    public func createCounterSign(offer: TransferOffer) throws -> CountersignedTransferRecord {
//        var counterSign = CountersignedTransferRecord(offer: offer)
//        try counterSign.sign(withReceiver: self)
//        return counterSign
//    }
//    
//    public func signForTransferOfferAndSubmit(offerId: String, action: TransferOfferAction) throws -> Bool {
//        let network = self.authKey.network
//        let api = API(network: network)
//        
//        let offer = try api.getTransferOffer(withId: offerId)
//        
//        let counterSign = try createCounterSign(offer: offer)
//        
//        return try api.completeTransferOffer(withAccount: self, offerId: offerId, action: action.rawValue, counterSignature: counterSign.counterSignature!.hexEncodedString)
//    }
//    
//    public func signForTransferOfferAndSubmit(offerId: String, offer: TransferOffer, action: String) throws -> Bool {
//        let network = self.authKey.network
//        let api = API(network: network)
//        
//        let counterSign = try createCounterSign(offer: offer)
//        
//        return try api.completeTransferOffer(withAccount: self, offerId: offerId, action: action, counterSignature: counterSign.counterSignature!.hexEncodedString)
//    }
//    
//    public func processTransferOffer(offer: TransferOffer) throws -> String {
//        let countersign = try createCounterSign(offer: offer)
//        
//        let network = self.authKey.network
//        let api = API(network: network)
//        
//        return try api.transfer(withData: countersign)
//    }
//}

extension String: Error {
    
}
