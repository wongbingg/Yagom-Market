//
//  SearchUserProfileUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import YagomMarket

final class SearchUserProfileUseCaseTests: XCTestCase {
    
    func test_UseCase실행시_FirestoreService의_read메서드가실행되는지() async throws {
        // given
        let expectationReadCallCount = 1
        let firestoreService = UserProfileFirestoreServiceMock()
        let useCase = SearchUserProfileUseCase(firestoreService: firestoreService)
        
        // when
        _ = try await useCase.execute()
        
        // then
        XCTAssertEqual(expectationReadCallCount, firestoreService.readCallCount)
    }
}
