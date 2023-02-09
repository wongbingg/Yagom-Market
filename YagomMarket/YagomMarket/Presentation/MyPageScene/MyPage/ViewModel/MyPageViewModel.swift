//
//  MyPageViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

struct MyPageViewModelActions {
    let registerTapSelected: () -> Void
    let searchTapSelected: () -> Void
    let logoutCellTapped: () -> Void
    let likedListCellTapped: ([ProductCell]) -> Void
    let myProductListCellTapped: ([ProductCell]) -> Void
}

protocol MyPageViewModelInput {
    func fetchVendorName() async throws -> String
    func searchTapSelected()
    func registerTapSelected()
    func logoutCellTapped()
    func likedListCellTapped() async throws
    func myProductListCellTapped() async throws
}

protocol MyPageViewModelOutput {}

protocol MyPageViewModel: MyPageViewModelInput, MyPageViewModelOutput {}

final class DefaultMyPageViewModel: MyPageViewModel {
    private let actions: MyPageViewModelActions
    private let searchQueryResultsUseCase: SearchQueryResultsUseCase
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    
    init(
        actions: MyPageViewModelActions,
        searchQueryResultsUseCase: SearchQueryResultsUseCase,
        searchUserProfileUseCase: SearchUserProfileUseCase,
        fetchProductDetailUseCase: FetchProductDetailUseCase
    ) {
        self.actions = actions
        self.searchQueryResultsUseCase = searchQueryResultsUseCase
        self.searchUserProfileUseCase = searchUserProfileUseCase
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
    }
    
    func fetchVendorName() async throws -> String {
        do {
            let userProfile = try await searchUserProfileUseCase.execute(othersUID: nil)
            return userProfile.vendorName
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    func searchTapSelected() {
        actions.searchTapSelected()
    }
    
    func registerTapSelected() {
        actions.registerTapSelected()
    }
    
    func logoutCellTapped() {
        actions.logoutCellTapped()
    }
    
    @MainActor
    func likedListCellTapped() async throws {
        let userProfile = try await searchUserProfileUseCase.execute(othersUID: nil)
        let ids = userProfile.likedProductIds
        var productCells = [ProductCell]()
        for id in ids {
            let response = try await fetchProductDetailUseCase.execute(productId: id)
            let productCell = response.toCell()
            productCells.append(productCell)
        }
        actions.likedListCellTapped(productCells)
    }
    
    @MainActor
    func myProductListCellTapped() async throws {
        let userProfile = try await searchUserProfileUseCase.execute(othersUID: nil)
        let searchKeyword = userProfile.vendorName
        let response = try await searchQueryResultsUseCase.execute(keyword: searchKeyword)
        actions.myProductListCellTapped(response.toDomain())
    }
}
