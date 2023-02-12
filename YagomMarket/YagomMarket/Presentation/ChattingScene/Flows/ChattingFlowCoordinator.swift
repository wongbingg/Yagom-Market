//
//  ChattingFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

protocol ChattingFlowCoordinatorDependencies: AnyObject {
    func makeChattingListViewController(
        actions: ChattingListViewModelActions) -> ChattingListViewController
    
    func makeChattingDetailViewController(
        chattingUUID: String) -> ChattingDetailViewController
    
    func makeRegisterViewController(
        model: ProductDetail?,
        actions: RegisterViewModelActions) -> RegisterViewController
    
    func makeModalFlowCoordinator(
        navigationController: UINavigationController) -> ModalFlowCoordinator
    
    func makeSearchFlowCoordinator(
        navigationController: UINavigationController) -> SearchFlowCoordinator
}

final class ChattingFlowCoordinator {
    private let modalFlowCoordinator: ModalFlowCoordinator
    private let searchFlowCoordinator: SearchFlowCoordinator
    private let navigationController: UINavigationController
    private let dependencies: ChattingFlowCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: ChattingFlowCoordinatorDependencies
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
            searchTapSelected: searchTapSelected,
            chattingCellTapped: chattingCellTapped
        )
        let chattingListVC = dependencies.makeChattingListViewController(actions: actions)
        return chattingListVC
    }
    
    // MARK: View Transition
    func registerTapSelected() {
        modalFlowCoordinator.presentRegisterVC(with: nil)
    }
    
    func searchTapSelected() {
        searchFlowCoordinator.start()
    }
    
    func chattingCellTapped(chattingUUID: String) {
        let chattingDetailVC = dependencies.makeChattingDetailViewController(
            chattingUUID: chattingUUID
        )
        navigationController.pushViewController(chattingDetailVC, animated: true)
    }
}
