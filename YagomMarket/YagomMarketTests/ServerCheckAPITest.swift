//
//  ServerCheckAPITest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/14.
//

import XCTest
@testable import YagomMarket

final class ServerCheckAPITest: XCTestCase {
    
    var sut: ServerCheckAPI!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ServerCheckAPI()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_서버가_활성화되었는지() {
        // given
        var response: String?
        let expectation = XCTestExpectation(description: "HealthCheckTest")
        // when
        sut.execute { result in
            // then
            switch result {
            case .success(let success):
                response = success
                expectation.fulfill()
            case .failure(let error):
                print(String(describing: error))
            }
        }
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(response)
        XCTAssertEqual(response, "\"OK\"")
    }
}
