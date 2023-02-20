//
//  ProductDetailViewModelTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/03.
//

import XCTest
@testable import YagomMarket

final class ProductDetailViewModelTests: XCTestCase {
    
    var sut: ProductDetailViewModel!
    var deleteProductUseCaseMock: DeleteProductUseCaseMock!

    override func setUpWithError() throws {
        deleteProductUseCaseMock = DeleteProductUseCaseMock()
        
        sut = DefaultProductDetailViewModel(
            deleteProductUseCase: deleteProductUseCaseMock,
            fetchProductDetailUseCase: FetchProductDetailUseCaseMock(),
            searchUserProfileUseCase: SearchUserProfileUseCaseMock(),
            handleLikedProductUseCase: HandleLikedProductUseCaseMock(),
            handleChattingUseCase: HandleChattingUseCaseMock(),
            searchOthersUIDUseCase: SearchOthersUIDUseCaseMock(),
            productId: 6
        )
    }

    override func tearDownWithError() throws {
        deleteProductUseCaseMock = nil
        sut = nil
    }
    // TODO: 테스트 진행
    
    func test_fetchProduct메서드실행시_예상한반환값이나오는지() async throws {
        // given
        let expectation = ProductDetail.stub()
        do {
            // when
            try await sut.fetchProduct()
            
            // then
            XCTAssertEqual(expectation, sut.productDetail)
        } catch let error as LocalizedError {
            
            print(error.errorDescription ?? "\(#function) error")
        }
    }
    
    func test_deleteProduct메서드실행시_DeleteProductUseCase를실행하는지() async throws {
        // given
        let expectationCallCount = 1
        do {
            // when
            try await sut.deleteProduct()
            
            // then
            XCTAssertEqual(expectationCallCount, deleteProductUseCaseMock.callCount)
        } catch let error as LocalizedError {
            
            print(error.errorDescription ?? "\(#function) error")
        }
    }
}
