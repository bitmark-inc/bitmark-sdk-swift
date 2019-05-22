//
//  KeychainStoreSample.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/15.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK


class KeychainStoreSample {
    private static let bitmarkSeedCoreKey = "bitmark_core"
    private static let reason = "The app would like to access to Keychain"
    
    static func saveAccountToKeychain(_ account: Account) throws {
        let keychain = try  KeychainUtil.getKeychain(reason: reason, authentication: false)
        try? keychain.removeAll()
        try keychain.set(account.seed.core, key: bitmarkSeedCoreKey)
    }
    
    static func getAccountFromKeychain() -> Account? {
        do {
            var account: Account? = nil
            let core = try KeychainUtil.getKeychain(reason: reason, authentication: false)
                .getData(bitmarkSeedCoreKey)
            
            if (core != nil) {
                let seed = try Seed.fromCore(core!, version: SeedVersion.v2)
                account = try Account(seed: seed)
            }
            
            return account
        } catch let e {
            print(e.localizedDescription)
            return nil
        }
    }
}
