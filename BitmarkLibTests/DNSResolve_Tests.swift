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
    
    func testTransfer() {
        do {
            let expectation = self.expectation(description: "DNSResolver")
            
            try DNSResolver.resolveTXT(Config.liveNet.staticHostName, handler: { (result) in
                switch result {
                case .success(let records):
                    XCTAssert(records.count > 0)
                case .failure(let error):
                    XCTFail("\(error)")
                }
                expectation.fulfill()
            })
        }
        catch {
            XCTFail()
        }
        
        self.waitForExpectations(timeout: 60) { (error) in
            print("Time out")
        }
    }
}
