//
//  DNSResolve_Tests.swift
//  BitmarkLib
//
//  Created by Anh Nguyen on 12/25/16.
//  Copyright © 2016 Bitmark. All rights reserved.
//

import XCTest
@testable import BitmarkLib

class DNSResolve_Tests: XCTestCase {
    
    // MARK:- Asset
    
    func testWithoutTimeout() {
        let expectation = self.expectation(description: "DNSResolver")
        
        DNSResolver.resolveTXT(Config.liveNet.staticHostName, handler: { (result) in
            switch result {
            case .success(let records):
                XCTAssert(records.count > 0)
            case .failure(let error):
                XCTFail("\(error)")
            }
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 61) { (error) in
            print("Time out")
        }
    }
    
    func testTimeout() {
        let expectation = self.expectation(description: "DNSResolver")
        
        DNSResolver.resolveTXT("www.google.com", timeout: 5, handler: { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssert(true)
            }
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 61) { (error) in
            print("Time out")
        }
    }
}
