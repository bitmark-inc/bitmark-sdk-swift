//
//  BitmarkIssuanceSample.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/15.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK

class BitmarkIssuanceSample {
    static func issueBitmarks(issuer: Account, assetId: String, quantity: Int) throws -> [String] {
        var issueParams = try Bitmark.newIssuanceParams(assetID: assetId,
                                                        quantity: quantity)
        try issueParams.sign(issuer)
        let bitmarkIds = try Bitmark.issue(issueParams)
        
        return bitmarkIds
    }
}
