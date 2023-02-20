//
//  SearchViewModelTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/03.
//

import XCTest
@testable import YagomMarket

final class SearchViewModelTests: XCTestCase {
    var goToResultVCCallCount = 0
    var goToHomeTabCallCount = 0
    var sut: SearchViewModel!
    
    override func setUpWithError() throws {
        let viewModelAction = SearchViewModelActions(
            goToResultVC: goToResultVC,
            goToHomeTab: goToHomeTab
        )
        
        func goToResultVC(cells: [ProductCell]) {
            goToResultVCCallCount += 1
        }
        
        func goToHomeTab() {
            goToHomeTabCallCount += 1
        }
        
        sut = DefaultSearchViewModel(
            actions: viewModelAction,
            searchQueryUseCase: SearchQueryUseCaseMock(),
            searchQueryResultsUseCase: SearchQueryResultsUseCaseMock()
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        goToResultVCCallCount = 0
        goToHomeTabCallCount = 0
    }
    
    func test_search메서드실행시_keyword에대한상품이_없을때_APIError_unknown에러를반환하는지() async throws {
        // given
        let expectationError = APIError.unknown
        
        // when
        do {
            try await sut.search(keyword: "invalid")
        } catch let error as APIError {
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
    
    func test_goToResultVC메서드실행시_keyword에대한상품이_없을때_APIError_unknown에러를반환하는지() async throws {
        // given
        let expectationError = APIError.unknown
        let expectationGoToResultVCCallCount = 0
        let expectationGoToHomeTabCallCount = 0
        
        // when
        do {
            try await sut.goToResultVC(with: "invalid")
        } catch let error as APIError {
            // then
            XCTAssertEqual(expectationError, error)
            XCTAssertEqual(expectationGoToResultVCCallCount, goToResultVCCallCount)
            XCTAssertEqual(expectationGoToHomeTabCallCount, goToHomeTabCallCount)
        }
    }
    
    func test_goToResultVC메서드실행시_keyword에대한상품이_있을때_viewModelAction_goToResultVC를하는지() async throws {
        // given
        let expectationGoToResultVCCallCount = 1
        let expectationGoToHomeTabCallCount = 0
        
        // when
        do {
            try await sut.goToResultVC(with: "valid keyword")
            // then
            XCTAssertEqual(expectationGoToResultVCCallCount, goToResultVCCallCount)
            XCTAssertEqual(expectationGoToHomeTabCallCount, goToHomeTabCallCount)
        } catch {
            XCTFail()
        }
    }
    
    func test_goToHomeTab메서드실행시_viewModelAction_goToHomeTab를하는지() {
        // given
        let expectationGoToResultVCCallCount = 0
        let expectationGoToHomeTabCallCount = 1
        
        // when
        sut.goToHomeTab()
        
        // then
        XCTAssertEqual(expectationGoToResultVCCallCount, goToResultVCCallCount)
        XCTAssertEqual(expectationGoToHomeTabCallCount, goToHomeTabCallCount)
    }
}
