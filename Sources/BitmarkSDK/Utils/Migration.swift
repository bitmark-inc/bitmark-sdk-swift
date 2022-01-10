//
//  Migration.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 11/26/18.
//  Copyright © 2018 Bitmark. All rights reserved.
//

import Foundation

public struct Migration {
//    public static func migrate(recoverPhrase: [String], language: RecoveryLanguage) throws -> (Account, [String]) {
//        let accountToMigrate = try Account(recoverPhrase: recoverPhrase, language: language)
//        if accountToMigrate.seed.version != .v1 {
//            throw("Only support migration from bitmark account version 1")
//        }
//
//        // Query for current owning bitmarks
//        var lastOffset: Int64? = nil
//        var owningBitmarks = [Bitmark]()
//        var shouldContinue = true
//        while shouldContinue {
//            var bitmarksQuery = Bitmark.newBitmarkQueryParams()
//                .owned(by: accountToMigrate.address)
//                .loadAsset(true)
//                .to(direction: .earlier)
//                .includePending(true)
//
//            if let lastOffset = lastOffset {
//                bitmarksQuery = bitmarksQuery.at(lastOffset)
//            }
//
//            let (bitmarks, _) = try Bitmark.list(params: bitmarksQuery)
//
//            if bitmarks == nil || bitmarks?.count == 0 {
//                break
//            }
//
//            if bitmarks!.count < 100 {
//                shouldContinue = false
//            }
//
//            lastOffset = bitmarks!.last!.offset
//
//            owningBitmarks += bitmarks!
//        }
//
//        // Group bitmarks with their asset_id
//        let assetBitmarkCountMap = Dictionary(grouping: owningBitmarks,
//                                         by: { $0.asset_id })
//            .mapValues( { $0.count } )
//
//        // Create a new bitmark account v2
//        let newAccount = try Account(version: .v2)
//
//        // Reissue new bitmarks with new account
//        var bitmarkIds = [String]()
//
//        for (assetId, count) in assetBitmarkCountMap {
//            var issuanceParam = try Bitmark.newIssuanceParams(assetID: assetId, owner: newAccount.accountNumber, quantity: count)
//            try issuanceParam.sign(accountToMigrate)
//            let result = try Bitmark.issue(issuanceParam)
//            bitmarkIds += result
//        }
//
//        return (newAccount, bitmarkIds)
//    }
    
    // Query and transfer all of current confirmed properties
    public static func rekey(from accountFrom: Account, to accountTo: Account, handler: ((Float, Error?) -> Void)?) {
        do {
            // Query for current owning bitmarks
            var lastOffset: Int64? = nil
            var owningBitmarks = [Bitmark]()
            var shouldContinue = true
            
            while shouldContinue {
                var bitmarksQuery = Bitmark.newBitmarkQueryParams()
                    .ownedBy(accountFrom.address)
                    .loadAsset(true)
                    .to(direction: .earlier)
                    .pending(false)
                
                if let lastOffset = lastOffset {
                    bitmarksQuery = bitmarksQuery.at(lastOffset)
                }
                
                let (bitmarks, _) = try Bitmark.list(params: bitmarksQuery)
                
                if bitmarks == nil || bitmarks?.count == 0 {
                    break
                }
                
                if bitmarks!.count < 100 {
                    shouldContinue = false
                }
                
                lastOffset = bitmarks!.last!.offset
                
                owningBitmarks += bitmarks!
            }
            
            if (owningBitmarks.count == 0) {
                handler?(Float(1), nil)
            } else {
                for i in 0..<owningBitmarks.count {
                    let bitmark = owningBitmarks[i]
                    
                    var params = try Bitmark.newOfferParams(to: accountTo.getAccountNumber(), info: nil)
                    try params.from(bitmarkID: bitmark.id)
                    try params.sign(accountFrom)
                    try Bitmark.offer(withOfferParams: params)
                }
                
                let query = Bitmark.newBitmarkQueryParams()
                    .offerTo(accountTo.getAccountNumber())
                let (bs, _) = try Bitmark.list(params: query)
                
                guard let offeringBitmarks = bs else {
                    handler?(0, "No bitmark found")
                    return
                }
                
                for i in 0..<offeringBitmarks.count {
                    let bitmark = offeringBitmarks[i]
                    var responseParams = try Bitmark.newTransferResponseParams(withBitmark: bitmark, action: .accept)
                    try responseParams.sign(accountTo)
                    _ = try Bitmark.respond(withResponseParams: responseParams)
                    
                    // Update progress
                    handler?(Float((i + 1)) / Float(owningBitmarks.count), nil)
                }
            }
        }
        catch let e {
            handler?(0, e)
        }
    }
}
