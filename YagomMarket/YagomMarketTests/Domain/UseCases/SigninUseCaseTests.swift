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
}
