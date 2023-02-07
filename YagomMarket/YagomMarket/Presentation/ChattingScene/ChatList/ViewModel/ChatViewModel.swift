//
//  ChatViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//
struct ChatViewModelActions {
    let registerTapSelected: () -> Void
    let searchTapSelected: () -> Void
}
protocol ChatViewModelInput {
    func searchTapSelected()
    func registerTapSelected()
}
protocol ChatViewModelOutput {}
protocol ChatViewModel: ChatViewModelInput, ChatViewModelOutput {}

final class DefaultChatViewModel: ChatViewModel {
    private let actions: ChatViewModelActions
    
    init(actions: ChatViewModelActions) {
        self.actions = actions
    }
    
    func searchTapSelected() {
        actions.searchTapSelected()
    }
    
    func registerTapSelected() {
        actions.registerTapSelected()
    }
}
