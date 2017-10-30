//
//  IssueHelper.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/26/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

public struct IssueHelper {
    
    public static func doIssue(fromData data: Data, name: String, metadata: [String: String]?, quantity: Int = 1, account: Account, completion: ((Bool) -> Void)?) {
        do {
            let network = account.authKey.network
            let fingerprint = FileUtil.Fingerprint.computeFingerprint(data: data)
            var asset = Asset()
            try asset.set(name: name)
            try asset.set(fingerPrint: fingerprint)
            if let metadata = metadata {
                try asset.set(metadata: metadata)
            }
            try asset.sign(withPrivateKey: account.authKey)
            
            var issues = [Issue]()
            for _ in 0..<quantity {
                var issue = Issue()
                issue.set(nonce: UInt64(arc4random()))
                issue.set(asset: asset)
                try issue.sign(privateKey: account.authKey)
                issues.append(issue)
            }
            
            // Upload asset
            let api = API(network: network)
            
            try api.uploadAsset(data: data,
                                fileName: name,
                                assetId: asset.id!,
                                accessibility: "public",
                                fromAccount: account,
                                completion: { (success) in
                                    if success {
                                        do {
                                            try api.issue(withIssues: issues, assets: [asset], completion: completion)
                                        }
                                        catch let e {
                                            print(e)
                                            completion?(false)
                                        }
                                    }
            })
        }
        catch let e {
            print(e)
            completion?(false)
        }
    }
}
