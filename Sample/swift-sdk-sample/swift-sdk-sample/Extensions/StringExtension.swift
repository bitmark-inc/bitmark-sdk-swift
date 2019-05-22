//
//  StringExtension.swift
//  swift-sdk-sample
//
//  Created by Dung Le on 2019/5/15.
//  Copyright © 2019 Bitmark. All rights reserved.
//

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
