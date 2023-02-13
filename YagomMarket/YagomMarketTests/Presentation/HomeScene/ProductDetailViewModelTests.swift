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
            handleChattingUseCase: HandleChattingUseCaseMock(),
            searchOthersUIDUseCase: SearchOthersUIDUseCaseMock(),
            productId: 1
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    // TODO: 테스트 진행
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
    
    func execute(othersUID: String?) async throws -> UserProfile {
        
        return UserProfile.stub(likedProductIds: [2,3,4,5])
    }
}

class HandleLikedProductUseCaseMock: HandleLikedProductUseCase {
    
    func execute(with productId: Int, isAdd: Bool) async throws {
        //
    }
}

class HandleChattingUseCaseMock: HandleChattingUseCase {
    func execute(chattingUUID: String, isAdded: Bool, othersUID: String?) async throws {
        //
    }
    
    
}

class SearchOthersUIDUseCaseMock: SearchOthersUIDUseCase {
    func execute(with vendorName: String) async throws -> UserUID {
        return UserUID(userUID: "")
    }
    
    
}
