//
//  ChattingListViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//
struct ChattingListViewModelActions {
    let registerTapSelected: () -> Void
    let searchTapSelected: () -> Void
}
protocol ChattingListViewModelInput {
    func searchTapSelected()
    func registerTapSelected()
}
protocol ChattingListViewModelOutput {}
protocol ChattingListViewModel: ChattingListViewModelInput, ChattingListViewModelOutput {}

final class DefaultChattingListViewModel: ChattingListViewModel {
    private let actions: ChattingListViewModelActions
    
    init(actions: ChattingListViewModelActions) {
        self.actions = actions
    }
    
    func searchTapSelected() {
        actions.searchTapSelected()
    }
    
    func registerTapSelected() {
        actions.registerTapSelected()
    }
}
