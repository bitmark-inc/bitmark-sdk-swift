//
//  Bitmark.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 12/23/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

struct Bitmark {
    // MARK:- Issue
    public static func newIssuanceParams(assetID: String, owner: AccountNumber, quantity: Int) throws -> IssuanceParams {
        let baseNonce = UInt64(Date().timeIntervalSince1970)
        var requests = [IssueRequest]()
        for i in 0..<quantity {
            var issuanceParams = IssueRequest()
            issuanceParams.set(assetId: assetID)
            issuanceParams.set(nonce: baseNonce + UInt64(i % 1000))
            requests.append(issuanceParams)
        }
        
        let params = IssuanceParams(issuances: requests)
        return params
    }
    
    public static func newIssuanceParams(assetID: String, owner: AccountNumber, nonces: [UInt64]) throws -> IssuanceParams {
        var requests = [IssueRequest]()
        for nonce in nonces {
            var issuanceParams = IssueRequest()
            issuanceParams.set(assetId: assetID)
            issuanceParams.set(nonce: nonce)
            requests.append(issuanceParams)
        }
        
        let params = IssuanceParams(issuances: requests)
        return params
    }
    
    public static func issue(_ params: IssuanceParams) throws -> [String] {
        let api = API()
        let bitmarkIDs = try api.issue(withIssueParams: params)
        
        return bitmarkIDs
    }
    
    // MARK:- Transfer
    public static func newTransferParams(to owner: AccountNumber) throws -> TransferParams {
        var transferRequest = TransferRequest()
        try transferRequest.set(to: owner)
        return TransferParams(transfer: transferRequest)
    }
    
    public static func transfer(withTransferParams params: TransferParams) throws -> String {
        let api = API()
        return try api.transfer(params)
    }
    
    // MARK:- Transfer offer
    public static func newOfferParams(to owner: AccountNumber, info: [String: Any]?) throws -> OfferParams {
        var transferRequest = TransferRequest()
        try transferRequest.set(to: owner)
        let offer = Offer(transfer: transferRequest, extraInfo: info)
        return OfferParams(offer: offer)
    }
    
    public static func transfer(withOfferParams params: OfferParams) throws {
        
    }
}
