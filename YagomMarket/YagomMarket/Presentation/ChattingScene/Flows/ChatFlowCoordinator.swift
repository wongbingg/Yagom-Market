//
//  ChatFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

protocol ChatFlowCoordinatorDependencies: AnyObject {
    func makeChatViewController(actions: ChattingListViewModelActions) -> ChattingListViewController
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController
    
    func makeModalFlowCoordinator(
        navigationController: UINavigationController) -> ModalFlowCoordinator
    
    func makeSearchFlowCoordinator(
        navigationController: UINavigationController) -> SearchFlowCoordinator
}

final class ChatFlowCoordinator {
    private let modalFlowCoordinator: ModalFlowCoordinator
    private let searchFlowCoordinator: SearchFlowCoordinator
    private let navigationController: UINavigationController
    private let dependencies: ChatFlowCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: ChatFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.modalFlowCoordinator = dependencies.makeModalFlowCoordinator(
            navigationController: navigationController
        )
        self.searchFlowCoordinator = dependencies.makeSearchFlowCoordinator(
            navigationController: navigationController
        )
    }
    
    func generate() -> ChattingListViewController {
        let actions = ChattingListViewModelActions(
            registerTapSelected: registerTapSelected,
            searchTapSelected: searchTapSelected
        )
        let chatVC = dependencies.makeChatViewController(actions: actions)
        return chatVC
    }
    
    // MARK: View Transition
    func registerTapSelected() {
        modalFlowCoordinator.presentRegisterVC(with: nil)
    }
    
    func searchTapSelected() {
        searchFlowCoordinator.start()
    }
}
