//
//  DetailViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/29.
//

import Foundation

struct ProductDetailViewModelActions {
    let imageTapped: ([String], Int) -> Void
    let showEditView: (ProductDetail) -> Void
}

protocol ProductDetailViewModelInput {
    func deleteProduct() async throws
    func showEditView() async throws
    func showImageViewer(imageURLs: [String], currentPage: Int)
    func addLikeProduct() async throws
    func deleteLikeProduct() async throws
}

protocol ProductDetailViewModelOutput {
    var productDetail: ProductDetail { get async throws }
    var isLiked: Bool { get async throws }
}

protocol ProductDetailViewModel: ProductDetailViewModelInput, ProductDetailViewModelOutput {}

final class DefaultProductDetailViewModel: ProductDetailViewModel {
    private let actions: ProductDetailViewModelActions?
    private let deleteProductUseCase: DeleteProductUseCase
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    private let handleLikedProductUseCase: HandleLikedProductUseCase
    private let productId: Int
    
    var productDetail: ProductDetail {
        get async throws {
            try await fetchProduct()
        }
    }
    
    var isLiked: Bool {
        get async throws {
            try await fetchIsLiked()
        }
    }
    
    init(
        actions: ProductDetailViewModelActions? = nil,
        deleteProductUseCase: DeleteProductUseCase,
        fetchProductDetailUseCase: FetchProductDetailUseCase,
        searchUserProfileUseCase: SearchUserProfileUseCase,
        handleLikedProductUseCase: HandleLikedProductUseCase,
        productId: Int
    ) {
        self.actions = actions
        self.deleteProductUseCase = deleteProductUseCase
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
        self.searchUserProfileUseCase = searchUserProfileUseCase
        self.handleLikedProductUseCase = handleLikedProductUseCase
        self.productId = productId
    }
    
    private func fetchProduct() async throws -> ProductDetail {
        let response = try await fetchProductDetailUseCase.execute(
            productId: productId
        )
        return response
    }
    
    private func fetchIsLiked() async throws -> Bool {
        let userProfile = try await searchUserProfileUseCase.execute()
        let likedProductIds = userProfile.likedProductIds
        
        return likedProductIds.contains(productId)
    }
    
    func deleteProduct() async throws {
        try await deleteProductUseCase.execute(productId: productId)
    }
    
    @MainActor
    func showEditView() async throws {
        let productDetail = try await productDetail
        actions?.showEditView(productDetail)
    }
    
    func showImageViewer(imageURLs: [String], currentPage: Int) {
        actions?.imageTapped(imageURLs, currentPage)
    }
    
    func addLikeProduct() async throws {
        try await handleLikedProductUseCase.execute(with: productId, isAdd: true)
    }
    
    func deleteLikeProduct() async throws {
        try await handleLikedProductUseCase.execute(with: productId, isAdd: false)
    }
}
