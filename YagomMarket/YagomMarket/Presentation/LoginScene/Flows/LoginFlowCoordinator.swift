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
    func makeSigninViewController(actions: SigninViewModelActions,
                                  socialLoginInfo: LoginInfo?) -> SigninViewController
    func makeTabBarController(navigationController: UINavigationController,
                              userUID: String) -> TabBarController
}

final class LoginFlowCoordinator {
    private var navigationController: UINavigationController!
    private var dependencies: LoginFlowCoordinatorDependencies
    
    
    init(navigationController: UINavigationController,
         dependencies: LoginFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginViewModelActions(
            successLogin: successLogin,
            createUserButtonTapped: signinButtonTapped
        )
        let loginVC = dependencies.makeLoginViewController(actions: actions)
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func successLogin(
        _ userUID: String,
        _ identifier: String,
        _ secret: String,
        _ vendorName: String) {
            
        LoginCacheManager.setNewLoginInfo(
            userUID: userUID,
            identifier: identifier,
            secret: secret,
            vendorName: vendorName
        )
        let tabBarController = dependencies.makeTabBarController(
            navigationController: navigationController,
            userUID: userUID
        )
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func signinButtonTapped(with socialLoginInfo: LoginInfo?) {
        let actions = SigninViewModelActions(backToLoginView: backToLoginView)
        let signinVC = dependencies.makeSigninViewController(
            actions: actions,
            socialLoginInfo: socialLoginInfo
        )
        navigationController.pushViewController(signinVC, animated: true)
    }
    
    // MARK: - View Transitions
    private func backToLoginView() {
        navigationController.popViewController(animated: true)
    }
}
