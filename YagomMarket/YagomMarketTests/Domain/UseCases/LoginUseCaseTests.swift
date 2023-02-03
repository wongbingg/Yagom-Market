//
//  LoginUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
import FirebaseAuth
@testable import YagomMarket

final class LoginUseCaseTests: XCTestCase {
    
    func test_UseCase를실행할때_FirebaseAuthService의_signIn메서드가실행되는지() async throws {
        // given
        let expectationCallCount = 1
        let firebaseAuthService = FirebaseAuthServiceMock()
        let useCase = DefaultLoginUseCase(firebaseAuthService: firebaseAuthService)
        
        // when
        _ = try await useCase.execute(with: LoginInfo(id: "", password: "", vendorName: ""))
        
        // then
        XCTAssertEqual(expectationCallCount, firebaseAuthService.signInCallCount)
    }
}
