//
//  KeychainUtil.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/17.
//  Copyright © 2019 Bitmark Inc. All rights reserved.
//

import Foundation
import KeychainAccess
import BitmarkSDK

struct KeychainUtil {
    static func getKeychain(reason: String, authentication: Bool) throws -> Keychain {
        #if (arch(i386) || arch(x86_64)) && os(iOS) && authentication
            let semaphore = DispatchSemaphore(value: 0)
            var cancel = false

            let alert = UIAlertController(title: "Keychain access request", message: reason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                semaphore.signal()
            }))
        
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                cancel = true
                semaphore.signal()
            }))

            UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)

            _ = semaphore.wait(timeout: .distantFuture)

            alert.dismiss(animated: true, completion: nil)

            if cancel {
                throw KeychainAccess.Status.userCanceled
            }
        #endif

        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            throw("Cannot get app information")
        }

        if authentication {
            return Keychain(service: bundleIdentifier)
                .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                .authenticationPrompt(reason)
        } else {
            return Keychain(service: bundleIdentifier)
        }
    }
}
