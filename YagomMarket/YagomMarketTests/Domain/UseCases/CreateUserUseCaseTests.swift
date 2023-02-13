//
//  CreateUserUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import YagomMarket

final class CreateUserUseCaseTests: XCTestCase {
    
    func test_UseCase를실행할때_FirebaseAuthService의_createUser메서드와_FirestoreService의_create메서드가실행되는지() async throws {
        // given
        let expectationCreateUserCallCount = 1
        let expectationCreateCallCount = 1
        let firebaseAuthService = FirebaseAuthServiceMock()
        let firestoreService = FirestoreServiceMock()
        let useCase = DefaultCreateUserUseCase(
            firebaseAuthService: firebaseAuthService,
            firestoreService: firestoreService
        )
        
        // when
        _ = try await useCase.execute(
            with: LoginInfo(
                id: "testId",
                password: "testPassword",
                vendorName: "",
                identifier: "",
                secret: ""
            )
        )
        
        // then
        XCTAssertEqual(expectationCreateUserCallCount, firebaseAuthService.createUserCallCount)
        XCTAssertEqual(expectationCreateCallCount, firestoreService.createCallCount)
    }
}
