//
//  AccountSample.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/14.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation

import BitmarkSDK

class AccountSample {
    static func createNewAccount() -> Account {
        let account = try! Account();
        return account;
    }
    
    static func getRecoveryPhraseFromAccount(account: Account) -> String {
        return try! account.getRecoverPhrase(language: .english).joined(separator: " ");
    }
    
    static func getAccountFromRecoveryPhrase(recoveryPhrase: String) throws -> Account {
        let phrases = recoveryPhrase.components(separatedBy: " ");
        return try Account(recoverPhrase: phrases, language: .english)
    }
}
