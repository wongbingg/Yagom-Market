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
            loginUseCase: makeLoginUseCase()
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
            createUserUseCase: makeCreateUserUseCase(),
            recordVendorNameUseCase: makeRecordVendorNameUseCase()
        )
    }
    
    // MARK: - TabBar
    func makeTabBarController(navigationController: UINavigationController,
                              userUID: String) -> TabBarController {
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let homeFlowCoordinator = homeSceneDIContainer.makeHomeFlowCoordinator(
            navigationController: navigationController,
            userUID: userUID
        )
        let homeVC = homeFlowCoordinator.generate()
        
        let searchSceneDIContainer = appDIContainer.makeSearchSceneDIContainer()
        let searchFlowCoordinator = searchSceneDIContainer.makeSearchFlowCoordinator(
            navigationController: navigationController
        )
        let searchVC = searchFlowCoordinator.generate()
        
        let chatSceneDIContainer = appDIContainer.makeChatSceneDIContainer()
        let chatFlowCoordinator = chatSceneDIContainer.makeChatFlowCoordinator(
            navigationController: navigationController
        )
        let chatVC = chatFlowCoordinator.generate()
        
        let myPageSceneDIContainer = appDIContainer.makeMyPageSceneDIContainer()
        let myPageFlowCoordinator = myPageSceneDIContainer.makeMyPageFlowCoordinator(
            navigationController: navigationController
        )
        let myPageVC = myPageFlowCoordinator.generate()
        
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
    func makeLoginUseCase() -> DefaultLoginUseCase {
        return DefaultLoginUseCase(firebaseAuthService: makeFirebaseAuthService())
    }
    
    func makeCreateUserUseCase() -> DefaultCreateUserUseCase {
        return DefaultCreateUserUseCase(
            firebaseAuthService: makeFirebaseAuthService(),
            firestoreService: makeFirestoreService()
        )
    }
    
    func makeRecordVendorNameUseCase() -> RecordVendorNameUseCase {
        return DefaultRecordVendorNameUseCase(
            firebaseAuthService: makeFirebaseAuthService(),
            firestoreService: makeOtherUIDFirestoreService()
        )
    }
    
    // MARK: - Services
    func makeFirebaseAuthService() -> FirebaseAuthService {
        return DefaultFirebaseAuthService()
    }
    
    func makeFirestoreService() -> DefaultFirestoreService<UserProfile> {
        return DefaultFirestoreService<UserProfile>()
    }
    
    func makeOtherUIDFirestoreService() -> DefaultFirestoreService<UserUID> {
        return DefaultFirestoreService<UserUID>()
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
