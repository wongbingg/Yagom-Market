//
//  SigninViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

struct SigninViewModelActions {
    let backToLoginView: () -> Void
}

protocol SigninViewModelInput {
    func registerButtonTapped(_ loginInfo: LoginInfo) async throws
}
protocol SigninViewModelOutput {}
protocol SigninViewModel: SigninViewModelInput, SigninViewModelOutput {}

final class DefaultSigninViewModel: SigninViewModel {
    private let actions: SigninViewModelActions?
    private let createUserUseCase: CreateUserUseCase
    private let recordVendorNameUseCase: RecordVendorNameUseCase

    init(
        actions: SigninViewModelActions? = nil,
        createUserUseCase: CreateUserUseCase,
        recordVendorNameUseCase: RecordVendorNameUseCase

    ) {
        self.actions = actions
        self.createUserUseCase = createUserUseCase
        self.recordVendorNameUseCase = recordVendorNameUseCase
    }

    func registerButtonTapped(_ loginInfo: LoginInfo) async throws {
        try loginInfo.validate()
        try await createUserUseCase.execute(with: loginInfo)
        try await recordVendorNameUseCase.execute(with: loginInfo.vendorName)
    }
}
