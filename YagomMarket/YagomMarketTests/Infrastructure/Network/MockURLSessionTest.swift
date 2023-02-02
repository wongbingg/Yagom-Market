//
//  MockURLSessionTest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/01/31.
//

import XCTest
@testable import YagomMarket

final class MockURLSessionTest: XCTestCase {
    
    func test_statusCode가_500일때_APIError_response를_반환하는지() async throws {
        // given
        let expectationError = APIError.response(500)
        
        let mockResponse: MockURLSession.Response = {
            let data: Data = Data()
            let failResponse = HTTPURLResponse(
                url: URL(string: "testURL")!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (data: data, urlResponse: failResponse)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        let apiClient = APIClient(sesseion: mockURLSession)
        let api = MockAPI()
        
        // when
        do {
            _ = try await api.execute(using: apiClient)
        } catch let error as APIError {
            
            // then
            XCTAssertEqual(error, expectationError)
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
    
    func test_URLSession_data메서드가실패했을때_APIError_invalidURLRequest를반환하는지() async throws {
        // given
        let expectationError = APIError.invalidURLRequest
        
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
        mockURLSession.dataMethodFail = true
        
        let apiClient = APIClient(sesseion: mockURLSession)
        let api = MockAPI()
        
        // when
        do {
            _ = try await api.execute(using: apiClient)
        } catch let error as APIError {
            
            // then
            XCTAssertEqual(error, expectationError)
        }
    }
}

final class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data, urlResponse: URLResponse)
    
    let response: Response
    var dataMethodFail = false
    
    init(response: Response) {
        self.response = response
    }
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        if dataMethodFail {
            throw APIError.unknown
        } else {
            return (response.data, response.urlResponse)
        }
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
