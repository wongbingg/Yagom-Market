//
//  SigninUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
import FirebaseAuth
@testable import YagomMarket

final class SigninUseCaseTests: XCTestCase {

    class FirebaseAuthServiceMock: FirebaseAuthService {
        var createUserCallCount = 0
        var signInCallCount = 0
        
        func createUser(email: String, password: String) async throws -> AuthDataResult? {
            createUserCallCount += 1
            return nil
        }
        
        func signIn(email: String, password: String) async throws -> AuthDataResult? {
            signInCallCount += 1
            if email == "invalidEmail" && password == "invalidPassword" {
                throw FirebaseAuthServiceError.signInError
            }
            return nil
        }
    }
    
    func test_UseCase를실행할때_FirebaseAuthService의_signIn메서드가실행되는지() async throws {
        // given
        let expectationCallCount = 1
        let firebaseAuthService = FirebaseAuthServiceMock()
        let useCase = SigninUseCase(firebaseAuthService: firebaseAuthService)
        
        // when
        _ = try await useCase.execute(with: LoginInfo(id: "", password: "", vendorName: ""))
        
        // then
        XCTAssertEqual(expectationCallCount, firebaseAuthService.signInCallCount)
    }
    
    func test_UseCase를실행할때_FirebaseAuthService에서오류가발생하면_signInError를반환하는지() async throws {
        // given
        let expectationError = FirebaseAuthServiceError.signInError
        let firebaseAuthService = FirebaseAuthServiceMock()
        let useCase = SigninUseCase(firebaseAuthService: firebaseAuthService)
        
        do {
            // when
            _ = try await useCase.execute(
                with: LoginInfo(
                    id: "invalidEmail",
                    password: "invalidPassword",
                    vendorName: ""
                )
            )
            XCTFail()
        } catch let error as FirebaseAuthServiceError {
            
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
}
