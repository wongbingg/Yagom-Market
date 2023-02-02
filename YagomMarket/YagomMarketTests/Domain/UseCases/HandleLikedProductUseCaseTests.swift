//
//  HandleLikedProductUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class HandleLikedProductUseCaseTests: XCTestCase {
    
    func test_UseCase가실행될때_FirestoreService의_read메서드와_update메서드가실행되는지() async throws {
        // given
        let expectationReadCallCount = 1
        let expectationUpdateCallCount = 1
        let firestoreService = UserProfileFirestoreServiceMock()
        let useCase = HandleLikedProductUseCase(firestoreService: firestoreService)
        
        // when
        _ = try await useCase.execute(with: 12, isAdd: true)
        
        // then
        XCTAssertEqual(expectationReadCallCount, firestoreService.readCallCount)
        XCTAssertEqual(expectationUpdateCallCount, firestoreService.updateCallCount)
    }
}
