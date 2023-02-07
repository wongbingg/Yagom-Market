//
//  ProductListViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

struct ProductListViewModelActions {
    let productTapped: (Int) -> Void
    let registerTapSelected: () -> Void
    let searchTapSelected: () -> Void
}

protocol ProductListViewModelInput {
    func resetToFirstPage() async throws
    func addNextPage() async throws
    func likeButtonTapped(id: Int, isSelected: Bool) async throws
    func didSelectItemAt(indexPath: Int)
    func registerTapSelected()
    func searchTapSelected()
}

protocol ProductListViewModelOutput {
    var productList: [ProductCell] { get }
    var userLikeList: [Int] { get }
}

protocol ProductListViewModel: ProductListViewModelInput, ProductListViewModelOutput {}

final class DefaultProductListViewModel: ProductListViewModel {
    private let actions: ProductListViewModelActions?
    private let addNextProductPageUseCase: AddNextProductPageUseCase
    private let handleLikedProductUseCase: HandleLikedProductUseCase
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    private(set) var productList: [ProductCell] = []
    private(set) var userLikeList: [Int] = []
    
    init(
        actions: ProductListViewModelActions? = nil,
        addNextProductPageUseCase: AddNextProductPageUseCase,
        handleLikedProductUseCase: HandleLikedProductUseCase,
        searchUserProfileUseCase: SearchUserProfileUseCase
    ) {
        self.actions = actions
        self.addNextProductPageUseCase = addNextProductPageUseCase
        self.handleLikedProductUseCase = handleLikedProductUseCase
        self.searchUserProfileUseCase = searchUserProfileUseCase
    }
    
    private func fetchUserLikeList() async throws {
        let userProfile = try await searchUserProfileUseCase.execute()
        userLikeList = userProfile.likedProductIds
    }
    
    func resetToFirstPage() async throws {
        try await fetchUserLikeList()
        addNextProductPageUseCase.resetToFirstPage()
        productList = try await addNextProductPageUseCase.execute()
    }
    
    func addNextPage() async throws {
        try await fetchUserLikeList()
        let response = try await addNextProductPageUseCase.execute()
        productList += response
    }
    
    func didSelectItemAt(indexPath: Int) {
        let id = productList[indexPath].id
        actions?.productTapped(id)
    }
    
    func refresh() {
        // TODO: 특정 상품 수정 후 homeview로 나왔을 때 특정 상품의 수정사항이 반영되도록 
    }
    
    func searchTapSelected() {
        actions?.searchTapSelected()
    }
    
    func registerTapSelected() {
        actions?.registerTapSelected()
    }
    
    func likeButtonTapped(id: Int, isSelected: Bool) async throws {
        try await handleLikedProductUseCase.execute(
            with: id,
            isAdd: isSelected
        )
    }
}
