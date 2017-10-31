//
//  Account+Services.swift
//  BitmarkSDK
//
//  Created by Anh Nguyen on 10/31/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import Foundation

public extension Account {
    
    public func issueBitmarks(assetFile url: URL,
                              accessibility: Accessibility = .publicAsset,
                              propertyName name: String,
                              propertyMetadata metadata: [String: String]? = nil,
                              quantity: Int = 1,
                              completion: ((Bool, [String?]?) -> Void)?) {
        do {
            let data = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
            let network = self.authKey.network
            let fingerprint = FileUtil.Fingerprint.computeFingerprint(data: data)
            var asset = Asset()
            try asset.set(name: name)
            try asset.set(fingerPrint: fingerprint)
            if let metadata = metadata {
                try asset.set(metadata: metadata)
            }
            try asset.sign(withPrivateKey: self.authKey)
            
            var issues = [Issue]()
            for _ in 0..<quantity {
                var issue = Issue()
                issue.set(nonce: UInt64(arc4random()))
                issue.set(asset: asset)
                try issue.sign(privateKey: self.authKey)
                issues.append(issue)
            }
            
            // Upload asset
            let api = API(network: network)
            
            try api.uploadAsset(data: data,
                                fileName: fileName,
                                assetId: asset.id!,
                                accessibility: .publicAsset, // TODO: Support private assets
                                fromAccount: self,
                                completion: { (success) in
                                    if success {
                                        do {
                                            try api.issue(withIssues: issues, assets: [asset], completion: completion)
                                        }
                                        catch let e {
                                            print(e)
                                            completion?(false, nil)
                                        }
                                    }
                                    else {
                                        completion?(false, nil)
                                    }
            })
        }
        catch let e {
            print(e)
            completion?(false, nil)
        }
        
    }
    
    public func transferBitmark(bitmarkId: String,
                                toAccount accountNumber: String,
                                completion: ((Bool) -> Void)?) {
        do {
            let network = self.authKey.network
            var transfer = Transfer()
            transfer.set(from: bitmarkId)
            try transfer.set(to: try AccountNumber(address: accountNumber))
            try transfer.sign(privateKey: self.authKey)
            
            let api = API(network: network)
            try api.transfer(withData: transfer, completion: completion)
        }
        catch let e {
            print(e)
            completion?(false)
        }
    }
}
