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

    override func setUpWithError() throws {
        sut = DefaultProductDetailViewModel(
            deleteProductUseCase: DeleteProductUseCaseMock(),
            fetchProductDetailUseCase: FetchProductDetailUseCaseMock(),
            searchUserProfileUseCase: SearchUserProfileUseCaseMock(),
            handleLikedProductUseCase: HandleLikedProductUseCaseMock(),
            productId: 1
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_productId에해당하는상품이없을때_productDetail에접근하면_APIError_unknown에러를반환하는지() async throws {
        // given
        let expectationError = APIError.unknown
        // when
        do {
            let productDetail = try await sut.productDetail
        } catch let error as LocalizedError {
            // then
            XCTAssertEqual(expectationError, error as! APIError)
        }
    }
    
    func test_UserProfile에서좋아요목록에productId가_없을때_isLiked에접근하면_false반환하는지() async throws {
        // given
        let expectation = false
        // when
        let response = try await sut.isLiked
        // then
        XCTAssertEqual(expectation, response)
    }
    
    func test_UserProfile에서좋아요목록에productId가_있을때_isLiked에접근하면_true반환하는지() async throws {
        // given
        sut = DefaultProductDetailViewModel(
            deleteProductUseCase: DeleteProductUseCaseMock(),
            fetchProductDetailUseCase: FetchProductDetailUseCaseMock(),
            searchUserProfileUseCase: SearchUserProfileUseCaseMock(),
            handleLikedProductUseCase: HandleLikedProductUseCaseMock(),
            productId: 3
        )
        let expectation = true
        // when
        let response = try await sut.isLiked
        // then
        XCTAssertEqual(expectation, response)
    }
}

class DeleteProductUseCaseMock: DeleteProductUseCase {
    
    func execute(productId: Int) async throws {
        //
    }
    
}

class FetchProductDetailUseCaseMock: FetchProductDetailUseCase {
    
    func execute(productId: Int) async throws -> ProductDetail {
        if productId == 1 {
            throw APIError.unknown
        }
        return ProductDetail.stub()
    }
}

class SearchUserProfileUseCaseMock: SearchUserProfileUseCase {
    
    func execute() async throws -> UserProfile {
        return UserProfile(vendorName: "", email: "", likedProductIds: [2,3,4,5])
    }
}

class HandleLikedProductUseCaseMock: HandleLikedProductUseCase {
    
    func execute(with productId: Int, isAdd: Bool) async throws {
        //
    }
}
