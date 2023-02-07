//
//  ResultViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/20.
//

struct ResultViewModelAction {
    let cellTapped: (Int) -> Void
}
protocol ResultViewModelInput {
    func fetchUserLikeList() async throws
    func likeButtonTapped(id: Int, isSelected: Bool) async throws
    func didSelectItemAt(indexPath: Int)
}
protocol ResultViewModelOutput {
    var productCells: [ProductCell] { get }
    var userLikeList: [Int] { get }
}

protocol ResultViewModel: ResultViewModelInput, ResultViewModelOutput {}

final class DefaultResultViewModel: ResultViewModel {
    private let handleLikedProductUseCase: HandleLikedProductUseCase
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    private(set) var userLikeList: [Int] = []
    var productCells: [ProductCell]
    let actions: ResultViewModelAction
    
    init(
        cells: [ProductCell],
        actions: ResultViewModelAction,
        handleLikedProductUseCase: HandleLikedProductUseCase,
        searchUserProfileUseCase: SearchUserProfileUseCase
    ) {
        self.productCells = cells
        self.actions = actions
        self.handleLikedProductUseCase = handleLikedProductUseCase
        self.searchUserProfileUseCase = searchUserProfileUseCase
    }
    
    func fetchUserLikeList() async throws {
        let userProfile = try await searchUserProfileUseCase.execute()
        userLikeList = userProfile.likedProductIds
    }
    
    func likeButtonTapped(id: Int, isSelected: Bool) async throws {
        try await handleLikedProductUseCase.execute(
            with: id,
            isAdd: isSelected
        )
    }
    
    func didSelectItemAt(indexPath: Int) {
        let id = productCells[indexPath].id
        actions.cellTapped(id)
    }
}
