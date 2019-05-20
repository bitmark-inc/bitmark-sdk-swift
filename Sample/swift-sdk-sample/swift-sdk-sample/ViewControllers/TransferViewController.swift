//
//  TransferViewController.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/17.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import UIKit
import BitmarkSDK

class TransferViewController: UIViewController {
    @IBOutlet var tfTransferBitmarkId: UITextField!
    @IBOutlet var tfReceiverAccountNumber: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tfRecoveryPhrase: UITextField!
    @IBOutlet var receiverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        receiverView.isHidden = true
    }
    
    @IBAction func transferOneSignatureHandler(_ sender: Any) {
        if !Global.needToHaveCurrentAccount(self) { return }
        
        let yourBitmarkId = tfTransferBitmarkId.text ?? ""
        
        if yourBitmarkId.isEmpty {
            Toast.show(message: "Please input Your Bitmark Id", controller: self)
            return
        }
        
        let receiverAccountNumber = tfReceiverAccountNumber.text ?? ""
        
        if receiverAccountNumber.isEmpty {
            Toast.show(message: "Please input Receiver Account Number", controller: self)
            return
        }
        
        var success = true
        activityIndicator.startAnimating();
        Tasker.runOnBackground {
            do {
                let _ = try BitmarkTransferSample.transferOneSignature(sender: Global.currentAccount!, bitmarkId: yourBitmarkId, receiverAccountNumber: receiverAccountNumber)
            } catch let e {
                print(e.localizedDescription)
                success = false
            }
            
            Tasker.runOnMain {
                self.activityIndicator.stopAnimating();
                if success == true {
                   Toast.show(message: "Transfer successfully!", controller: self)
                } else {
                    Toast.show(message: "Can not transfer Bitmark", controller: self)
                }
            }
        }
    }
    
    @IBAction func sendTransferOfferHandler(_ sender: Any) {
        if !Global.needToHaveCurrentAccount(self) { return }
        
        let yourBitmarkId = tfTransferBitmarkId.text ?? ""
        
        if yourBitmarkId.isEmpty {
            Toast.show(message: "Please input Your Bitmark Id", controller: self)
            return
        }
        
        let receiverAccountNumber = tfReceiverAccountNumber.text ?? ""
        
        if receiverAccountNumber.isEmpty {
            Toast.show(message: "Please input Receiver Account Number", controller: self)
            return
        }
        
        var success = true
        activityIndicator.startAnimating();
        Tasker.runOnBackground {
            do {
                try BitmarkTransferSample.sendTransferOffer(sender: Global.currentAccount!, bitmarkId: yourBitmarkId, receiverAccountNumber: receiverAccountNumber)
            } catch let e {
                print(e.localizedDescription)
                success = false
            }
            
            Tasker.runOnMain {
                self.activityIndicator.stopAnimating();
                if success == true {
                    self.receiverView.isHidden = false
                    Toast.show(message: "Send transfer offer successfully!", controller: self)
                } else {
                    Toast.show(message: "Can not send transfer offer", controller: self)
                }
            }
        }
    }
    
    @IBAction func acceptTransferOfferHanlder(_ sender: Any) {
        let transferBitmarkId = tfTransferBitmarkId.text ?? ""
        
        if transferBitmarkId.isEmpty {
            Toast.show(message: "Please input Your Bitmark Id", controller: self)
            return
        }
        
        let recoveryPhrase = tfRecoveryPhrase.text ?? ""
        
        if recoveryPhrase.isEmpty {
            Toast.show(message: "Please input Recovery Phrase", controller: self)
            return
        }
        
        var receiverAccount: Account
        do {
            receiverAccount = try AccountSample.getAccountFromRecoveryPhrase(recoveryPhrase: recoveryPhrase)
        } catch let e {
            print(e.localizedDescription)
            Toast.show(message: "Can not get account from Recovery Phrase", controller: self)
            return
        }
        
        var success = true
        activityIndicator.startAnimating();
        Tasker.runOnBackground {
            do {
                try BitmarkTransferSample.acceptTransferOffer(receiver: receiverAccount, bitmarkId: transferBitmarkId)
            } catch let e {
                print(e.localizedDescription)
                success = false
            }
            
            Tasker.runOnMain {
                self.activityIndicator.stopAnimating();
                if success == true {
                    Toast.show(message: "Accepted successfully!", controller: self)
                } else {
                    Toast.show(message: "Can not accept transfer offer", controller: self)
                }
            }
        }
    }
}
