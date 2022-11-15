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
        let expectation = "OK"
        // when
        ServerCheckAPI.execute { result in
            // then
            XCTAssertEqual(expectation, result)
        }
    }
}
