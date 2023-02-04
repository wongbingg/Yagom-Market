//
//  SigninViewModelTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/03.
//

import XCTest
@testable import YagomMarket

final class SigninViewModelTests: XCTestCase {
    var backToLoginViewCallCount = 0
    var sut: SigninViewModel!
    
    override func setUpWithError() throws {
        backToLoginViewCallCount = 0
        let firebaseAuthService = FirebaseAuthServiceMock()
        let firestoreService = UserProfileFirestoreServiceMock()
        let useCase = CreateUserUseCaseMock(
            firebaseAuthService: firebaseAuthService,
            firestoreService: firestoreService
        )
        
        sut = DefaultSigninViewModel(createUserUseCase: useCase)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_이메일이유효하지않을때_LoginError_invalidEmail에러를반환하는지() async throws {
        // given
        let expectationError = LoginError.invalidEmail
        let loginInfo = LoginInfo(id: "123", password: "123", vendorName: "")
        
        // when
        do {
            try await sut.registerButtonTapped(loginInfo)
        } catch let error as LoginError {
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
    
    func test_비밀번호가유효하지않을때_LoginError_invalidPassword에러를반환하는지() async throws {
        // given
        let expectationError = LoginError.invalidPassword(number: 2)
        let loginInfo = LoginInfo(id: "test@naver.com", password: "12", vendorName: "")
        
        // when
        do {
            try await sut.registerButtonTapped(loginInfo)
        } catch let error as LoginError {
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
    
    func test_useCase에서오류를반환했을때_viewModel에서도같은오류를반환하는지() async throws {
        // given
        let expectationError = FirebaseAuthServiceError.failToCreateUser
        let loginInfo = LoginInfo(id: "test@naver.com", password: "123456", vendorName: "invalid")
        
        // when
        do {
            try await sut.registerButtonTapped(loginInfo)
        } catch let error as FirebaseAuthServiceError {
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
}

class CreateUserUseCaseMock: CreateUserUseCase {
    let firebaseAuthService: FirebaseAuthService
    let firestoreService: any FirestoreService
    
    init(
        firebaseAuthService: FirebaseAuthService,
        firestoreService: any FirestoreService
    ) {
        self.firebaseAuthService = firebaseAuthService
        self.firestoreService = firestoreService
    }
    
    func execute(with loginInfo: LoginInfo) async throws {
        if loginInfo.vendorName == "invalid" {
            throw FirebaseAuthServiceError.failToCreateUser
        }
    }
    
}
