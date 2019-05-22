//
//  CommonUtil.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/15.
//  Copyright © 2019 Bitmark. All rights reserved.
//

import Foundation
import BitmarkSDK

class CommonUtil {
    private static let ALPHA_NUMERIC_STRING = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    static func randomAlphaNumeric(count: Int) -> String {
        var index = count;
        var randomString = ""
        while (index > 0) {
            let characterIndex = Int.random(in: 0 ..< ALPHA_NUMERIC_STRING.count)
            randomString.append(ALPHA_NUMERIC_STRING[characterIndex])
            index-=1
        }
        return randomString;
    }
    
    static func writeFile(text: String, fileName: String) throws -> String {
        var filePath = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            filePath = fileURL.relativePath
        }
        
        return filePath
    }
    
    static func setClipboard(text: String) {
        UIPasteboard.general.string = text
    }
}
