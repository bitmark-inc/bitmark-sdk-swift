//
//  Tasker.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/20.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation

class Tasker {
    static func runOnBackground(work: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            work()
        }
    }
    
    static func runOnMain(work: @escaping () -> ()) {
        DispatchQueue.main.async {
            work()
        }
    }
}
