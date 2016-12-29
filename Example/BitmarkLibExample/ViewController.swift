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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Pool.getNodeURLs(fromNetwork: Config.testNet) { (urls) in
            print(urls)
            
            Connection.shared.startConnection(from: urls, completionHandler: {
                
                var asset = Asset()
                var issue = Issue()
                let issueNonce = BigUInt(1475482198529)
                do {
                    try asset.set(name: TestData.name)
                    try asset.set(metadata: TestData.metadata)
                    try asset.set(fingerPrint: TestData.fingerprint)
                    
                    try asset.sign(withPrivateKey: TestData.privateKey)
                    
                    let issuePk = try PrivateKey.init(fromKIF: "ce5MNS5PwvZ1bo5cU9Fex7He2tMpFP2Q42ToKZTBEBdA5f4dXm")
                    
                    issue.set(asset: asset)
                    issue.set(nonce: issueNonce)
                    try issue.sign(privateKey: issuePk)
                    
                    Connection.shared.createBitmarks(assets: [asset], issues: [issue], callbackHandler: { (results) in
                        print(results)
                    })
                }
                catch {
                    
                }
            })
            

        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

