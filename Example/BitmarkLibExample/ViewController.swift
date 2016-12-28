//
//  ViewController.swift
//  BitmarkLibExample
//
//  Created by Anh Nguyen on 12/26/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import UIKit
import BitmarkLib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Pool.getNodeURLs(fromNetwork: Config.testNet) { (urls) in
            print(urls)
            
            Connection.shared.startConnection(from: urls, completionHandler: { 
                Connection.shared.nodeInfo(callbackHandler: { (info) in
                    print(info)
                })
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

