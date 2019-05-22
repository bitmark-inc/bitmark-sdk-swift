//
//  SDKInitializationSample.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/14.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK

class SDKInitializationSample {
    static func initialize(config: SDKConfig) {
        BitmarkSDK.initialize(config: config)
    }
}
