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
            loginUseCase: makeLoginUseCase(),
            searchUserProfileUseCase: makeSearchUserProfileUseCase(),
            kakaoLoginUseCase: makeKakaoLoginUseCase(),
            facebookLoginUseCase: makeFacebookLoginUseCase()
        )
    }
    
    // MARK: - Signin
    func makeSigninViewController(actions: SigninViewModelActions,
                                  socialLoginInfo: LoginInfo?) -> SigninViewController {
        let viewModel = makeSigninViewModel(
            actions: actions,
            socialLoginInfo: socialLoginInfo
        )
        return SigninViewController(with: viewModel)
    }
    
    func makeSigninViewModel(actions: SigninViewModelActions,
                             socialLoginInfo: LoginInfo?) -> SigninViewModel {
        return DefaultSigninViewModel(
            actions: actions,
            createUserUseCase: makeCreateUserUseCase(),
            recordVendorNameUseCase: makeRecordVendorNameUseCase(),
            socialLoginInfo: socialLoginInfo
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
        
        let chattingSceneDIContainer = appDIContainer.makeChattingSceneDIContainer()
        let chattingFlowCoordinator = chattingSceneDIContainer.makeChattingFlowCoordinator(
            navigationController: navigationController
        )
        let chatVC = chattingFlowCoordinator.generate()
        
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
    
    func makeSearchUserProfileUseCase() -> SearchUserProfileUseCase {
        return DefaultSearchUserProfileUseCase(
            firestoreService: makeFirestoreService()
        )
    }
    
    func makeKakaoLoginUseCase() -> KakaoLoginUseCase {
        return DefaultKakaoLoginUseCase(
            kakaoService: makeKakaoService()
        )
    }
    
    func makeFacebookLoginUseCase() -> FacebookLoginUseCase {
        return DefaultFacebookLoginUseCase(
            facebookService: makeFacebookService()
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
    
    func makeKakaoService() -> KakaoService {
        return DefaultKakaoService()
    }
    
    func makeFacebookService() -> FacebookService {
        return DefaultFacebookService()
    }
    
    // MARK: - Login Flow Coordinator
    func makeLoginFlowCoordinator(
        navigationController: UINavigationController) -> LoginFlowCoordinator {
            
        return LoginFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension LoginSceneDIContainer: LoginFlowCoordinatorDependencies {}
