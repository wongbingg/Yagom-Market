//
//  LoginViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation
import FirebaseAuth
import FacebookCore
import UIKit

struct LoginViewModelActions {
    let successLogin: (String, String, String, String) -> Void
    let createUserButtonTapped: (LoginInfo?) -> Void
}

protocol LoginViewModelInput {
    func loginButtonTapped(with loginInfo: LoginInfo) async throws
    func createUserButtonTapped(with socialLoginInfo: LoginInfo?)
    func kakaoLogoButtonTapped()
    func facebookButtonTapped(in viewController: UIViewController)
}

protocol LoginViewModelOutput {}

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {}

final class DefaultLoginViewModel: LoginViewModel {
    private let actions: LoginViewModelActions?
    private let loginUseCase: LoginUseCase
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    private let kakaoLoginUseCase: KakaoLoginUseCase
    private let facebookLoginUseCase: FacebookLoginUseCase
    
    init(
        actions: LoginViewModelActions? = nil,
        loginUseCase: LoginUseCase,
        searchUserProfileUseCase: SearchUserProfileUseCase,
        kakaoLoginUseCase: KakaoLoginUseCase,
        facebookLoginUseCase: FacebookLoginUseCase
    ) {
        self.actions = actions
        self.loginUseCase = loginUseCase
        self.searchUserProfileUseCase = searchUserProfileUseCase
        self.kakaoLoginUseCase = kakaoLoginUseCase
        self.facebookLoginUseCase = facebookLoginUseCase
    }
    
    @MainActor
    func loginButtonTapped(with loginInfo: LoginInfo) async throws {
        try loginInfo.validate()
        let userUID = try await loginUseCase.execute(with: loginInfo)
        if let userUID = userUID {
            let userProfile = try await searchUserProfileUseCase.execute(othersUID: userUID)
            let identifier = userProfile.identifier
            let secret = userProfile.secret
            let vendorName = userProfile.vendorName
            actions?.successLogin(userUID, identifier, secret, vendorName)
        }
    }
    
    func createUserButtonTapped(with socialLoginInfo: LoginInfo?) {
        actions?.createUserButtonTapped(socialLoginInfo)
    }
    
    func kakaoLogoButtonTapped() {
        kakaoLoginUseCase.execute { loginInfo in
            Task {
                do {
                    _ = try await self.loginUseCase.execute(with: loginInfo)
                    try await self.loginButtonTapped(with: loginInfo)
                } catch {
                    DispatchQueue.main.async {
                        self.createUserButtonTapped(with: loginInfo)
                    }
                }
            }
        }
    }
    
    func facebookButtonTapped(in viewController: UIViewController) {
        facebookLoginUseCase.execute(in: viewController) { loginInfo in
            Task {
                do {
                    _ = try await self.loginUseCase.execute(with: loginInfo)
                    try await self.loginButtonTapped(with: loginInfo)
                } catch {
                    DispatchQueue.main.async {
                        self.createUserButtonTapped(with: loginInfo)
                    }
                }
            }
        }
    }
}
