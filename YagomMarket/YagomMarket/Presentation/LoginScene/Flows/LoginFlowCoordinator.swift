//
//  LoginFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit
import FirebaseAuth

protocol LoginFlowCoordinatorDependencies: AnyObject {
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
    func makeSigninViewController(actions: SigninViewModelActions) -> SigninViewController
}

final class LoginFlowCoordinator {
    private var navigationController: UINavigationController!
    private var dependencies: LoginFlowCoordinatorDependencies
    private let appDIContainer = AppDIContainer()
    
    init(navigationController: UINavigationController,
         dependencies: LoginFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginViewModelActions(
            successLogin: successLogin(_:),
            signinButtonTapped: signinButtonTapped
        )
        let loginVC = dependencies.makeLoginViewController(actions: actions)
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    private func successLogin(_ userUID: String) {
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let flow1 = homeSceneDIContainer.makeHomeFlowCoordinator(
            navigationController: navigationController,
            fireStoreCollectionId: userUID
        )
        let homeVC = flow1.generate()
        
        let searchSceneDIContainer = appDIContainer.makeSearchSceneDIContainer()
        let flow2 = searchSceneDIContainer.makeSearchFlowCoordinator()
        let searchVC = flow2.generate()
        
        let chatSceneDIContainer = appDIContainer.makeChatSceneDIContainer()
        let flow3 = chatSceneDIContainer.makeChatFlowCoordinator(
            navigationController: navigationController
        )
        let chatVC = flow3.generate()
        
        let myPageSceneDIContainer = appDIContainer.makeMyPageSceneDIContainer()
        let flow4 = myPageSceneDIContainer.makeMyPageFlowCoordinator(
            navigationController: navigationController
        )
        let myPageVC = flow4.generate()
        
        let registerVC = RegisterViewController(with: DefaultRegisterViewModel())
        
        let tabBarController = TabBarController(
            homeVC: homeVC,
            searchVC: searchVC,
            registerVC: registerVC,
            chatVC: chatVC,
            myPageVC: myPageVC
        )
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func signinButtonTapped() {
        let actions = SigninViewModelActions(backToLoginView: backToLoginView)
        let signinVC = dependencies.makeSigninViewController(actions: actions)
        navigationController.pushViewController(signinVC, animated: true)
    }
    
    // MARK: - View Transitions
    private func backToLoginView() {
        navigationController.popViewController(animated: true)
    }
}
