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
    let createUserButtonTapped: () -> Void
}

protocol LoginViewModelInput {
    func loginButtonTapped(with loginInfo: LoginInfo) async throws
    func createUserButtonTapped()
}

protocol LoginViewModelOutput {}

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {}

final class DefaultLoginViewModel: LoginViewModel {
    private let actions: LoginViewModelActions?
    private let loginUseCase: LoginUseCase
    
    init(
        actions: LoginViewModelActions? = nil,
        loginUseCase: LoginUseCase
    ) {
        self.actions = actions
        self.loginUseCase = loginUseCase
    }
    
    @MainActor
    func loginButtonTapped(with loginInfo: LoginInfo) async throws {
        try loginInfo.validate()
        let response = try await loginUseCase.execute(with: loginInfo)
        if let response = response {
            actions?.successLogin(response)
        }
    }
    
    func createUserButtonTapped() {
        actions?.createUserButtonTapped()
    }
}
