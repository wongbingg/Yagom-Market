//
//  MockURLSessionTest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/01/31.
//

import XCTest
@testable import YagomMarket

final class MockURLSessionTest: XCTestCase {
    var sut: APIClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_statusCode가_500일때_APIError_response를_반환하는지() async throws {
        // given
        let mockResponse: MockURLSession.Response = {
            let data: Data = Data()
            let successResponse = HTTPURLResponse(
                url: URL(string: "testURL")!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (data: data, urlResponse: successResponse)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        let sut = APIClient(sesseion: mockURLSession)
        
        let expectation = APIError.response(500).errorDescription
        
        // when
        do {
            _ = try await sut.requestData(with: URLRequest(url: URL(string: "testURL")!))
        } catch let error as APIError {
            
            // then
            XCTAssertEqual(error.errorDescription, expectation)
        }
    }
    
    func test_JSONDecoding이_실패했을때_APIError_failToParse를_반환하는지() async throws {
        // given
        let mockResponse: MockURLSession.Response = {
            let data: Data = try! JSONEncoder().encode("abc")
            let successResponse = HTTPURLResponse(
                url: URL(string: "testURL")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (data: data, urlResponse: successResponse)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        let apiClient = APIClient(sesseion: mockURLSession)
        let api = MockAPI()
        
        let expectation = APIError.failToParse.errorDescription
        
        // when
        do {
            _ = try await api.execute(using: apiClient)
            XCTFail()
        } catch let error as APIError {
            
            // then
            XCTAssertEqual(error.errorDescription, expectation)
        }
    }
}

final class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data, urlResponse: URLResponse)
    
    let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        return (response.data, response.urlResponse)
    }
}

struct MockAPI: API {
    typealias ResponseType = ProductListResponseDTO
    let configuration: APIConfiguration?
    
    init() {
        configuration = APIConfiguration(
            method: .get,
            base: "testURL",
            path: "",
            parameters: nil
        )
    }
}
