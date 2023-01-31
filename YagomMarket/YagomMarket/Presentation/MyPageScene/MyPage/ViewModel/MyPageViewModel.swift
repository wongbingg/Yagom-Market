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
    let likedListCellTapped: () -> Void
    let myProductListCellTapped: (ProductListResponseDTO) -> Void
}
protocol MyPageViewModelInput {
    func searchTapSelected()
    func registerTapSelected()
    func logoutCellTapped()
    func likedListCellTapped()
    func myProductListCellTapped() async throws
}
protocol MyPageViewModelOutput {}
protocol MyPageViewModel: MyPageViewModelInput, MyPageViewModelOutput {}

final class DefaultMyPageViewModel: MyPageViewModel {
    private let actions: MyPageViewModelActions
    private let searchQueryResultsUseCase: SearchQueryResultsUseCase
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    
    init(
        actions: MyPageViewModelActions,
        searchQueryResultsUseCase: SearchQueryResultsUseCase,
        searchUserProfileUseCase: SearchUserProfileUseCase
    ) {
        self.actions = actions
        self.searchQueryResultsUseCase = searchQueryResultsUseCase
        self.searchUserProfileUseCase = searchUserProfileUseCase
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
    
    func likedListCellTapped() {
        actions.likedListCellTapped()
    }
    
    @MainActor
    func myProductListCellTapped() async throws {
        let userProfile = try await searchUserProfileUseCase.execute()
        let searchKeyword = userProfile.vendorName
        let response = try await searchQueryResultsUseCase.execute(keyword: searchKeyword)
        actions.myProductListCellTapped(response)
    }
}
