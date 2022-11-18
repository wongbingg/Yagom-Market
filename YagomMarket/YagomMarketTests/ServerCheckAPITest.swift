//
//  ServerCheckAPITest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/14.
//

import XCTest
@testable import YagomMarket

final class ServerCheckAPITest: XCTestCase {
    
    func test_서버가_활성화되었는지() {
        // given
        let response = "OK"
        let expectation = XCTestExpectation(description: "HealthCheckTest")
        // when
        ServerCheckAPI.execute { result in
            // then
            XCTAssertEqual(response, result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
