//
//  AccountViewController.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/14.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import UIKit
import BitmarkSDK
import KeychainAccess

class AccountViewController: UIViewController {

    @IBOutlet var lblAccountNumber: UILabel!
    @IBOutlet var lblRecoveryPhrase: UILabel!
    @IBOutlet var tfRecoveryPhrase: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lblAccountNumberTap = UITapGestureRecognizer(target: self, action: #selector(self.lblAccountNumberTapHandler));
        lblAccountNumber.addGestureRecognizer(lblAccountNumberTap);
        
        let lblRecoveryPhraseTap = UITapGestureRecognizer(target: self, action: #selector(self.lblRecoveryPhraseTapHanlder));
        lblRecoveryPhrase.addGestureRecognizer(lblRecoveryPhraseTap);
        
        // Load account from Keychain if any
        let account = KeychainStoreSample.getAccountFromKeychain()
        
        if account != nil {
            Global.currentAccount = account
            renderAccountInfo(account: Global.currentAccount!)
        }
    }
    
    @IBAction func createNewAccountHandler(_ sender: UIButton) {
        do {
            let account = AccountSample.createNewAccount()
            Global.currentAccount = account
            renderAccountInfo(account: Global.currentAccount!)
            try KeychainStoreSample.saveAccountToKeychain(account)
        } catch let e {
            print(e.localizedDescription)
            
            if let status = e as? KeychainAccess.Status, status == KeychainAccess.Status.userCanceled || status == KeychainAccess.Status.authFailed {
                Toast.show(message: "Can not store KeyChain", controller: self)
            } else {
                Toast.show(message: "Can not create account", controller: self)
            }
        }
    }
    
    @IBAction func recoverAccountHandler(_ sender: UIButton) {
        let recoveryPhrase = tfRecoveryPhrase.text ?? ""
        if recoveryPhrase.isEmpty {
            Toast.show(message: "Please input Recovery Phrase", controller: self)
            return
        }
        
        do {
            Global.currentAccount = try AccountSample.getAccountFromRecoveryPhrase(recoveryPhrase: recoveryPhrase)
            renderAccountInfo(account: Global.currentAccount!)
            try KeychainStoreSample.saveAccountToKeychain(Global.currentAccount!)
            Toast.show(message: "Recovered successfully!", controller: self)
        } catch let e {
            print(e.localizedDescription)
            if let status = e as? KeychainAccess.Status, status == KeychainAccess.Status.userCanceled || status == KeychainAccess.Status.authFailed {
                Toast.show(message: "Can not store KeyChain", controller: self)
            } else {
                Toast.show(message: "Can not recover account", controller: self)
            }
        }
    }
    
    private func renderAccountInfo(account: Account) {
        lblAccountNumber.text = account.getAccountNumber()
        lblRecoveryPhrase.text = AccountSample.getRecoveryPhraseFromAccount(account: account)
    }
    
    @objc
    func lblAccountNumberTapHandler(sender: UITapGestureRecognizer) {
        CommonUtil.setClipboard(text: lblAccountNumber.text!)
        Toast.show(message: "Copied!", controller: self)
    }
    
    @objc
    func lblRecoveryPhraseTapHanlder(sender: UITapGestureRecognizer) {
        CommonUtil.setClipboard(text: lblRecoveryPhrase.text!)
        Toast.show(message: "Copied!", controller: self)
    }
}

