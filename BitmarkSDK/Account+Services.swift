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
                                accessibility: accessibility,
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
                                toAccount recipient: String) throws -> Bool {
        do {
            let network = self.authKey.network
            let api = API(network: network)
            // Get asset's access information
            
            guard let assetAccess = try api.getAssetAccess(account: self, bitmarkId: bitmarkId) else {
                print("Failed to get asset's access")
                return false
            }
            
            if assetAccess.sessionData != nil {
                let senderEncryptionPublicKey = self.encryptionKey.publicKey.hexEncodedString
                
                let assetEnryption = try AssetEncryption.encryptionKey(fromSessionData: assetAccess.sessionData!,
                                                                       account: self,
                                                                       senderEncryptionPublicKey: senderEncryptionPublicKey.hexDecodedData,
                                                                       senderAuthPublicKey: self.authKey.publicKey)
                
                guard let recipientEncrPubkey = try api.getEncryptionPublicKey(accountNumber: recipient) else {
                    return false
                }
                
                let sessionData = try SessionData.createSessionData(account: self,
                                                                sessionKey: assetEnryption.key, forRecipient: recipientEncrPubkey.hexDecodedData)
                
                let result = try api.updateSession(account: self, bitmarkId: bitmarkId, recipient: recipient, sessionData: sessionData)
                if result == false {
                    print("Fail to update session data")
                    return false
                }
            }
            
            var transfer = Transfer()
            transfer.set(from: bitmarkId)
            try transfer.set(to: try AccountNumber(address: recipient))
            try transfer.sign(privateKey: self.authKey)
            
            return try api.transfer(withData: transfer)
        }
    }
    
    public func downloadAsset(bitmarkId: String, completion: ((Data?) -> Void)?) {
        let network = self.authKey.network
        let api = API(network: network)
        api.downloadAsset(bitmarkId: bitmarkId, completion: completion)
    }
    
    public func registerPublicEncryptionKey(completion: ((Bool) -> Void)?) throws {
        let network = self.authKey.network
        let api = API(network: network)
        try api.registerEncryptionPublicKey(forAccount: self, completion: completion)
    }
}
