//
//  Global.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/14.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK

class Global {
    static var currentAccount: Account? = nil
    
    static func needToHaveCurrentAccount(_ controller: UIViewController) -> Bool {
        let hasCurrentAccount = currentAccount != nil;
        
        if (!hasCurrentAccount) {
            Toast.show(message: "Please create account first", controller: controller)
        }
        
        return hasCurrentAccount
    }
}
