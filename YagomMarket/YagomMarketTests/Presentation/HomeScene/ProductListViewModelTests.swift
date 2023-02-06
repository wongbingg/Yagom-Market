//
//  ProductListViewModelTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/03.
//

import XCTest
@testable import YagomMarket

final class ProductListViewModelTests: XCTestCase {
    var sut: ProductListViewModel!

    override func setUpWithError() throws {
        let useCase = AddNextProductPageUseCaseMock()
        
        sut = DefaultProductListViewModel(
            addNextProductPageUseCase: useCase
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_다음페이지가존재하지않을때_viewModel의addNextPage메서드실행시_ProductsRepositoryError_noNextPage오류가반환되는지() async throws {
        // given
        let expectationError = ProductsRepositoryError.noNextPage
        
        let useCase = AddNextProductPageUseCaseMock()
        useCase.hasNext = false
        
        sut = DefaultProductListViewModel(
            addNextProductPageUseCase: useCase
        )
        
        // when
        do {
            try await sut.addNextPage()
            XCTFail()
        } catch let error as ProductsRepositoryError {
            
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
}

class AddNextProductPageUseCaseMock: AddNextProductPageUseCase {
    var hasNext: Bool = true

    func execute() async throws -> [ProductCell] {
        guard hasNext == true  else { throw ProductsRepositoryError.noNextPage }
        
        return [ProductCell.stub()]
    }
    
    func resetToFirstPage() {
        hasNext = true
    }
    
}
