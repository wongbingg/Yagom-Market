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
    
    func test_서버가_활성화되었는지() async throws {
        // given
        var response: String?
        // when
        response = try await sut.execute()
        print(response!)
        // then
        XCTAssertEqual(response, "\"OK\"")
    }
}
