//
//  Array+Extension.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/28/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var mode: Element? {
        return self.reduce([Element: Int]()) {
            var counts = $0
            counts[$1] = ($0[$1] ?? 0) + 1
            return counts
            }.max { $0.1 < $1.1 }?.0
    }
}
