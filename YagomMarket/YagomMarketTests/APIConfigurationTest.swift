//
//  APIConfigurationTest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/15.
//

import XCTest
@testable import YagomMarket

final class APIConfigurationTest: XCTestCase {
    
    func test_APIConfiguration으로_HealthChecker_url을생성할수있는지() {
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
    
    func test_APIConfiguration으로_상품리스트조회_url을생성할수있는지() {
        // given
        let urlComponents = URLComponents(string: "https://openmarket.yagom-academy.kr/api/products?page_no=1&item_per_page=1")
        let expextationQueryItems = Set(urlComponents?.queryItems ?? [])
        let expectationMethod: HTTPMethod = .get
        
        let param = ["page_no": 1, "item_per_page": 1]
        let apiConfig = APIConfiguration(method: .get,
                                         base: URLCommand.host,
                                         path: URLCommand.products,
                                         parameters: param)
        // when
        let resultComponent = URLComponents(string: apiConfig.url?.absoluteString ?? "")
        let resultQueryItem = Set(resultComponent?.queryItems ?? [])
        let resultMethod = apiConfig.method
        
        // then
        XCTAssertEqual(expextationQueryItems, resultQueryItem)
        XCTAssertEqual(expectationMethod, resultMethod)
    }
    
    func test_APIConfiguration으로_상품상세조회_url을생성할수있는지() {
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
