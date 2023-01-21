//
//  MyPageFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

protocol MyPageFlowCoordinatorDependencies: AnyObject {
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController
}

final class MyPageFlowCoordinator {
    var navigationController: UINavigationController?
    var dependencies: MyPageFlowCoordinatorDependencies
    
    init(dependencies: MyPageFlowCoordinatorDependencies) {
        self.dependencies = dependencies
    }
    
    func generate() -> UINavigationController? {
        let actions = MyPageViewModelActions(
            registerTapSelected: registerTapSelected,
            searchTapSelected: searchTapSelected
        )
        let myPageVC = dependencies.makeMyPageViewController(actions: actions)
        navigationController = UINavigationController(rootViewController: myPageVC)
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

