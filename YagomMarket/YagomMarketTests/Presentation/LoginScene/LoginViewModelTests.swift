//
//  LoginViewModelTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/03.
//

import XCTest
import FirebaseAuth
@testable import YagomMarket

final class LoginViewModelTests: XCTestCase {
    var successLoginCallCount = 0
    var createUserButtonTappedCallCount = 0
    var sut: LoginViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        successLoginCallCount = 0
        createUserButtonTappedCallCount = 0
        
        let viewModelActions = LoginViewModelActions(
            successLogin: successLogin,
            createUserButtonTapped: createUserButtonTapped
        )
        
        func successLogin(_ a: String, _ b: String, _ c: String, _ d: String) {
            successLoginCallCount += 1
        }
        
        func createUserButtonTapped() {
            createUserButtonTappedCallCount += 1
        }

        let useCase = LoginUseCaseMock()
        sut = DefaultLoginViewModel(
            actions: viewModelActions,
            loginUseCase: useCase,
            searchUserProfileUseCase: SearchUserProfileUseCaseMock()
        )
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_이메일형식이잘못입력되었을때_LoginError_invalidEmail오류를반환하는지() async throws {
        // given
        let expectationError = LoginError.invalidEmail
        
        let loginInfo = LoginInfo(id: "12",
                                  password: "123456",
                                  vendorName: "",
                                  identifier: "",
                                  secret: "")
        
        // when
        do {
            try await sut.loginButtonTapped(with: loginInfo)
        } catch let error as LoginError {
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
    
    func test_비밀번호가잘못입력되었을때_LoginError_invalidPassword오류를반환하는지() async throws {
        // given
        let expectationError = LoginError.invalidPassword(number: 3)
        
        let loginInfo = LoginInfo(id: "test@naver.com",
                                  password: "123",
                                  vendorName: "",
                                  identifier: "",
                                  secret: "")
        
        // when
        do {
            try await sut.loginButtonTapped(with: loginInfo)
        } catch let error as LoginError {
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
    
    func test_viewModel에서_loginButtonTapped메서드가실행되고_유효성검사가통과하면_viewModelActions의_successLogin이실행되는지() async throws {
        // given
        let expectationSuccessLoginCallCount = 1
        let expectationCreateUserButtonTappedCallCount = 0
        
        let loginInfo = LoginInfo(id: "test@naver.com",
                                  password: "123456",
                                  vendorName: "",
                                  identifier: "",
                                  secret: "")
        
        // when
        try await sut.loginButtonTapped(with: loginInfo)
        
        // then
        XCTAssertEqual(expectationSuccessLoginCallCount, successLoginCallCount)
        XCTAssertEqual(expectationCreateUserButtonTappedCallCount, createUserButtonTappedCallCount)
    }
    
    func test_viewModel에서_createUserButtonTapped메서드가실행되면_viewModelActions의_createUserButtonTapped가실행되는지() {
        // given
        let expectationSuccessLoginCallCount = 0
        let expectationCreateUserButtonTappedCallCount = 1
        
        // when
        sut.createUserButtonTapped()
        
        // then
        XCTAssertEqual(expectationSuccessLoginCallCount, successLoginCallCount)
        XCTAssertEqual(expectationCreateUserButtonTappedCallCount, createUserButtonTappedCallCount)
    }
    
    func test_UseCase에서오류가발생했을때_viewModel에서_같은오류를반환하는지() async throws {
        // given
        let expectationError = FirebaseAuthServiceError.failToLogin

        let loginInfo = LoginInfo(id: "test@naver.com",
                                  password: "123456",
                                  vendorName: "invalid",
                                  identifier: "",
                                  secret: "")
        
        // when
        do {
            try await sut.loginButtonTapped(with: loginInfo)
        } catch let error as FirebaseAuthServiceError {
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
}

class LoginUseCaseMock: LoginUseCase {
    
    func execute(with loginInfo: YagomMarket.LoginInfo) async throws -> String? {
        if loginInfo.vendorName == "invalid" {
            throw FirebaseAuthServiceError.failToLogin
        }
        return "userUID"
    }
}
