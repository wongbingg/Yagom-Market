//
//  LoginViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation
import FirebaseAuth
//import FacebookCore
import UIKit

struct LoginViewModelActions {
    let successLogin: (String) -> Void
    let signinButtonTapped: () -> Void
}

protocol LoginViewModelInput {
    func loginButtonTapped(with loginInfo: LoginInfo) async throws
    func signinButtonTapped()
}

protocol LoginViewModelOutput {}

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {}

final class DefaultLoginViewModel: LoginViewModel {
    private let actions: LoginViewModelActions?
    private let signinUseCase: SigninUseCase
    private let loginCacheManager: LoginCacheManager
    
    init(
        actions: LoginViewModelActions? = nil,
        signinUseCase: SigninUseCase,
        loginCacheManager: LoginCacheManager
    ) {
        self.actions = actions
        self.signinUseCase = signinUseCase
        self.loginCacheManager = loginCacheManager
    }
    
    @MainActor
    func loginButtonTapped(with loginInfo: LoginInfo) async throws {
        try loginInfo.validate()
        let response = try await signinUseCase.execute(with: loginInfo)
        if let response = response {
            actions?.successLogin(response.user.uid)            
        }
    }
    
    func signinButtonTapped() {
        actions?.signinButtonTapped()
    }
}
