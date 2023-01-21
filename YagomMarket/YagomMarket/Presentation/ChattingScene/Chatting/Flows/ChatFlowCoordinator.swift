//
//  ChatFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

protocol ChatFlowCoordinatorDependencies: AnyObject {
    func makeChatViewController(actions: ChatViewModelActions) -> ChatViewController
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController
}

final class ChatFlowCoordinator {
    var navigationController: UINavigationController?
    var dependencies: ChatFlowCoordinatorDependencies
    
    init(dependencies: ChatFlowCoordinatorDependencies) {
        self.dependencies = dependencies
    }
    
    func generate() -> UINavigationController? {
        let actions = ChatViewModelActions(
            registerTapSelected: registerTapSelected,
            searchTapSelected: searchTapSelected
        )
        let chatVC = dependencies.makeChatViewController(actions: actions)
        navigationController = UINavigationController(rootViewController: chatVC)
        return navigationController
    }
    
    // MARK: View Transition
    func registerTapSelected() {
        let actions = RegisterViewModelActions(registerButtonTapped: registerButtonTapped,
                                               editButtonTapped: editButtonTapped)
        let registerVC = dependencies.makeRegisterViewController(model: nil, actions: actions)
        registerVC.modalPresentationStyle = .overFullScreen
        navigationController?.topViewController?.present(registerVC, animated: true)
    }
    
    func searchTapSelected() {
        let searchSceneDIContainer = SearchSceneDIContainer()
        let coordinator = searchSceneDIContainer.makeSearchFlowCoordinator(
            navigationController: navigationController!
        )
        coordinator.start()
    }
    
    func registerButtonTapped() {
        print("등록버튼 탭")
    }
    
    func editButtonTapped() {
        print("수정버튼 탭")
    }
}
