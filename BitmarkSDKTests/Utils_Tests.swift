//
//  Utils_Tests.swift
//  BitmarkSDKTests
//
//  Created by Anh Nguyen on 10/31/17.
//  Copyright © 2017 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkSDK

class Utils_Tests: XCTestCase {
    
    func testRandomBytesLength() {
        XCTAssertEqual(Common.randomBytes(length: 32).count, 32)
    }
    
    func testTimeStampLength() {
        XCTAssertEqual(Common.timeStamp().count, 13)
    }
}
