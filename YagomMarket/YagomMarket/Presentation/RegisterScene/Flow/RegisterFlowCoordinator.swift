//
//  RegisterFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

protocol RegisterFlowCoordinatorDependencies: AnyObject {
    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController
}

final class RegisterFlowCoordinator {
    var navigationController = UINavigationController()
    var dependencies: RegisterFlowCoordinatorDependencies
    
    init(dependencies: RegisterFlowCoordinatorDependencies) {
        self.dependencies = dependencies
    }
    
    func start() {
//        let actions = ProductListViewModelActions(
//            productTapped: productTapped(id:),
//            anotherTabTapped: anotherTabTapped
//        )
//        let homeVC = dependencies.makeProductListViewController(actions: actions)
//        navigationController.pushViewController(homeVC, animated: true)
    }
    // test
    func generate() -> RegisterViewController {
        let actions = RegisterViewModelActions(registerButtonTapped: registerButtonTapped)
        let registerVC = dependencies.makeRegisterViewController(actions: actions)
        return registerVC
    }
    
    // MARK: View Transition
    func registerButtonTapped() {
        // 등록 또는 수정 후 dismiss
    }
}
