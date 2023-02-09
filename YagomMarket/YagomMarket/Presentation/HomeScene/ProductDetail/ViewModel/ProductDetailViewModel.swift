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
    func fetchProduct() async throws
    func deleteProduct() async throws
    func showEditView() async throws
    func showImageViewer(imageURLs: [String], currentPage: Int)
    func addLikeProduct() async throws
    func deleteLikeProduct() async throws
}

protocol ProductDetailViewModelOutput {
    var productDetail: ProductDetail? { get }
}

protocol ProductDetailViewModel: ProductDetailViewModelInput, ProductDetailViewModelOutput {}

final class DefaultProductDetailViewModel: ProductDetailViewModel {
    private let actions: ProductDetailViewModelActions?
    private let deleteProductUseCase: DeleteProductUseCase
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    private let handleLikedProductUseCase: HandleLikedProductUseCase
    private let handleChattingUseCase: HandleChattingUseCase
    private let searchOthersUIDUseCase: SearchOthersUIDUseCase
    private let productId: Int
    
    var productDetail: ProductDetail?
    
    init(
        actions: ProductDetailViewModelActions? = nil,
        deleteProductUseCase: DeleteProductUseCase,
        fetchProductDetailUseCase: FetchProductDetailUseCase,
        searchUserProfileUseCase: SearchUserProfileUseCase,
        handleLikedProductUseCase: HandleLikedProductUseCase,
        handleChattingUseCase: HandleChattingUseCase,
        searchOthersUIDUseCase: SearchOthersUIDUseCase,
        productId: Int
    ) {
        self.actions = actions
        self.deleteProductUseCase = deleteProductUseCase
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
        self.searchUserProfileUseCase = searchUserProfileUseCase
        self.handleLikedProductUseCase = handleLikedProductUseCase
        self.handleChattingUseCase = handleChattingUseCase
        self.searchOthersUIDUseCase = searchOthersUIDUseCase
        self.productId = productId
    }
    
    func fetchProduct() async throws {
        var fetchedProduct = try await fetchProductDetailUseCase.execute(
            productId: productId
        )
        fetchedProduct.isLiked = try await fetchIsLiked()
        productDetail = fetchedProduct
    }
    
    private func fetchIsLiked() async throws -> Bool {
        let userProfile = try await searchUserProfileUseCase.execute(othersUID: nil)
        let likedProductIds = userProfile.likedProductIds
        
        return likedProductIds.contains(productId)
    }
    
    func deleteProduct() async throws {
        try await deleteProductUseCase.execute(productId: productId)
    }
    
    func chattingButtonTapped() async throws {
        guard let userUID = LoginCacheManager.fetchPreviousInfo() else { return }
        let othersUID = try await searchOthersUIDUseCase.execute(with: "vendorName") // vendorName을 넣어준다
        let chattingUUID = userUID + "%" + othersUID.userUID + "%" + UUID().uuidString
        
        try await handleChattingUseCase.execute(
            chattingUUID: chattingUUID,
            isAdded: true,
            othersUID: nil
        )
        try await handleChattingUseCase.execute(
            chattingUUID: chattingUUID,
            isAdded: true,
            othersUID: othersUID.userUID
        )
    }
    
    @MainActor
    func showEditView() async throws {
        guard let productDetail = productDetail else { return }
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
