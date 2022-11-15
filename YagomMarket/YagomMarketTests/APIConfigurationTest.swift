//
//  APIConfigurationTest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/15.
//

import XCTest
@testable import YagomMarket

final class APIConfigurationTest: XCTestCase {
    
    func test_APIConfiguration으로_원하는url을생성할수있는지_1() {
        // given
        let expectationURL = URL(string: "https://openmarket.yagom-academy.kr/healthChecker")
        let expectationMethod: HTTPMethod = .get
        let apiConfig = APIConfiguration(method: .get,
                                         base: URLCommand.host,
                                         path: URLCommand.healthChecker,
                                         parameters: nil)
        // when
        let resultURL = apiConfig.url
        let resultMethod = apiConfig.method
        // then
        XCTAssertEqual(expectationURL, resultURL)
        XCTAssertEqual(expectationMethod, resultMethod)
    }
    
    func test_APIConfiguration으로_원하는url을생성할수있는지_2() {
        // given
        let expectationURL = URL(string: "https://openmarket.yagom-academy.kr/api/products?page_no=1&item_per_page=1")
        let expectationMethod: HTTPMethod = .get
        
        let param = ["page_no":"1", "item_per_page":"1"]
        let apiConfig = APIConfiguration(method: .get,
                                         base: URLCommand.host,
                                         path: URLCommand.products,
                                         parameters: param)
        // when
        let resultURL = apiConfig.url
        let resultMethod = apiConfig.method
        
        // then
        XCTAssertEqual(expectationURL, resultURL)
        XCTAssertEqual(expectationMethod, resultMethod)
    }
    
    func test_APIConfiguration으로_원하는url을생성할수있는지_3() {
        // given
        let expectationURL = URL(string: "https://openmarket.yagom-academy.kr/api/products/179")
        let expectationMethod: HTTPMethod = .get
        
        let productId = 179
        let apiConfig = APIConfiguration(method: .get,
                                         base: URLCommand.host,
                                         path: "\(URLCommand.products)/\(productId)",
                                         parameters: nil)
        // when
        let resultURL = apiConfig.url
        let resultMethod = apiConfig.method
        
        // then
        XCTAssertEqual(expectationURL, resultURL)
        XCTAssertEqual(expectationMethod, resultMethod)
    }
}
