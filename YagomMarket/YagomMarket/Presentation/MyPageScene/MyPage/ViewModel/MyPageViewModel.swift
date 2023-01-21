//
//  MyPageViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

struct MyPageViewModelActions {
    let registerTapSelected: () -> Void
    let searchTapSelected: () -> Void
}
protocol MyPageViewModelInput {
    func searchTapSelected()
    func registerTapSelected()
}
protocol MyPageViewModelOutput {}
protocol MyPageViewModel: MyPageViewModelInput, MyPageViewModelOutput {}

final class DefaultMyPageViewModel: MyPageViewModel {
    private let actions: MyPageViewModelActions
    
    init(actions: MyPageViewModelActions) {
        self.actions = actions
    }
    
    func searchTapSelected() {
        actions.searchTapSelected()
    }
    
    func registerTapSelected() {
        actions.registerTapSelected()
    }
}
