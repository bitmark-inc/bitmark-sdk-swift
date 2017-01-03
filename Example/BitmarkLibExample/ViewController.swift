//
//  ViewController.swift
//  BitmarkLibExample
//
//  Created by Anh Nguyen on 12/26/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import UIKit
import BitmarkLib
import BigInt

class ViewController: UIViewController {
    
    struct TestData {
        static let privateKey = try! PrivateKey(fromKIF: "Zjbm1pyA1zjpy5RTeHtBqSAr2NvErTxsovkbWs1duVy8yYG9Xr")
        static let name = "this is name"
        static let metadata = "description" + "\u{0000}" + "this is description"
        static let fingerprint = "5b071fe12fd7e624cac31b3d774715c11a422a3ceb160b4f1806057a3413a13c"
        static let signature = "2028900a6ddebce59e29fb41c27b45be57a07177927b24e46662e007ecad066399e87f4dec4eecb45599e9e9186497374978595a36f908b4fed9a51145b6e803"
    }
    
    let pk1 = try! PrivateKey(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
    let pk2 = try! PrivateKey(fromKIF: "ddZdMwNbSoAKV72w5EHAfhJMShN9JphvSgpdAhWu7JYmEAeiQm")
    
    var asset1 = Asset()
    var asset2 = Asset()
    var issue1 = Issue()
    var issue2 = Issue()
    
    var transfer1 = Transfer()
    let transfer2 = Transfer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try asset1.set(name: "Test Bitmark Lib")
            try asset1.set(metadata: ["description": "Asset description"])
            try asset1.set(fingerPrint: "Test Bitmark Lib 11")
            try asset1.sign(withPrivateKey: pk1)
            
            try asset2.set(name: "Test Bitmark Lib")
            try asset2.set(metadata: ["description": "Asset description"])
            try asset2.set(fingerPrint: "Test Bitmark Lib 12")
            try asset2.sign(withPrivateKey: pk2)
            
            issue1.set(asset: asset1)
            issue1.set(nonce: BigUInt(1475482198529))
            try issue1.sign(privateKey: pk1)
            
            issue2.set(asset: asset1)
            issue2.set(nonce: BigUInt(1475482198530))
            try issue2.sign(privateKey: pk2)
            
        }
        catch {
            
        }
        
        
        print("Connecting to livenet")
        Connection.shared.setNetwork(Config.testNet)
        
        
        createBitmarks {
            
        }
        
//        transferBitmark {
//            
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    func createBitmarks(_ completionHandler: () -> Void) {
        print("================= CREATE BITMARK ======================================================================");
        
        Connection.shared.onReady {
            Connection.shared.createBitmarks(assets: [self.asset1, self.asset2], issues: [self.issue1, self.issue2], callbackHandler: { (results) in
                let result = results.result!
                let issuePayId = result["payId"] as! String
                let issuePayNonce = result["payNonce"] as! String
                let issueDifficulty = result["difficulty"] as! String
                
                let issuePayIdData = issuePayId.hexDecodedData
                let issuePayNonceData = issuePayNonce.hexDecodedData
                let issueDifficultyData = issueDifficulty.hexDecodedData
                let nonce = Common.findNonce(base: (issuePayIdData + issuePayNonceData), difficulty: issueDifficultyData)
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 4, execute: {
                    
                    Connection.shared.payByHashCash(params: ["payId": issuePayId, "nonce": nonce.hexEncodedString], callbackHandler: { (nodeResult) in
                        print(nodeResult)
                    })
                })
            })
        }
    }
    
    func transferBitmark(_ completionHandler: () -> Void) {
        print("================= PAY FOR ISSUE ======================================================================");
        
        transfer1.set(from: issue1)
        try! transfer1.set(to: pk2.address)
        try! transfer1.sign(privateKey: pk1)
        
        let params = try! transfer1.getRPCParam()
        
        Connection.shared.onReady {
            Connection.shared.transferBitmarks(params: params, callbackHandler: { (nodeResult) in
                print(nodeResult)
            })
        }
    }
}
