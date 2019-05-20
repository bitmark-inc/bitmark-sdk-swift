//
//  AssetRegistrationSample.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/15.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK

class AssetRegistrationSample {
    static func registerAsset(registrant: Account, assetName: String,
                              assetFilePath: String,
                              metadata: Dictionary<String, String>) throws -> String {
        var assetParams = try Asset.newRegistrationParams(name: assetName, metadata: metadata)
        try assetParams.setFingerprint(fromFileURL: assetFilePath)
        try assetParams.sign(registrant)
        let assetId = try Asset.register(assetParams)
        
        return assetId
    }
}
