//
//  LoginSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class LoginSceneDIContainer {
    private let appDIContainer = AppDIContainer()
    
    // MARK: - Login
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        let viewModel = makeLoginViewModel(actions: actions)
        return LoginViewController(with: viewModel)
    }
    
    func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        return DefaultLoginViewModel(
            actions: actions,
            signinUseCase: makeSigninUseCase(),
            loginCacheManager: LoginCacheManager()
        )
    }
    
    // MARK: - Signin
    func makeSigninViewController(actions: SigninViewModelActions) -> SigninViewController {
        let viewModel = makeSigninViewModel(actions: actions)
        return SigninViewController(with: viewModel)
    }
    
    func makeSigninViewModel(actions: SigninViewModelActions) -> SigninViewModel {
        return DefaultSigninViewModel(
            actions: actions,
            createUserUseCase: makeCreateUserUseCase()
        )
    }
    
    // MARK: - TabBar
    func makeTabBarController(navigationController: UINavigationController,
                              userUID: String) -> TabBarController {
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let flow1 = homeSceneDIContainer.makeHomeFlowCoordinator(
            navigationController: navigationController,
            userUID: userUID
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
        
        return tabBarController
    }
    
    // MARK: - UseCase
    func makeSigninUseCase() -> SigninUseCase {
        return SigninUseCase(firebaseAuthService: makeFirebaseAuthService())
    }
    
    func makeCreateUserUseCase() -> CreateUserUseCase {
        return CreateUserUseCase(firebaseAuthService: makeFirebaseAuthService())
    }
    
    // MARK: - Services
    func makeFirebaseAuthService() -> FirebaseAuthService {
        return DefaultFirebaseAuthService()
    }
    
    // MARK: - Login Flow Coordinator
    func makeLoginFlowCoordinator(navigationController: UINavigationController) -> LoginFlowCoordinator {
        return LoginFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension LoginSceneDIContainer: LoginFlowCoordinatorDependencies {}
