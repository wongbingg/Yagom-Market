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
    let successLogin: (String, String, String, String) -> Void
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
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    
    init(
        actions: LoginViewModelActions? = nil,
        loginUseCase: LoginUseCase,
        searchUserProfileUseCase: SearchUserProfileUseCase
    ) {
        self.actions = actions
        self.loginUseCase = loginUseCase
        self.searchUserProfileUseCase = searchUserProfileUseCase
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
    
    func createUserButtonTapped() {
        actions?.createUserButtonTapped()
    }
}
