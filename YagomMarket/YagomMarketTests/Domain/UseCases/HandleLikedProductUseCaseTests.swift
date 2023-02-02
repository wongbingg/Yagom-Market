//
//  HandleLikedProductUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class HandleLikedProductUseCaseTests: XCTestCase {
    
    class FirestoreServiceMock<E: Entity>: FirestoreService {
        typealias T = E
        var firestore: [Entity] = []
        var readCallCount = 0
        var updateCallCount = 0
        
        func create<T>(collectionId: String,
                       documentId: String,
                       entity: T) async throws where T : YagomMarket.Entity {
        }
        
        func read<T>(collectionId: String,
                     documentId: String,
                     entity: T) async throws -> T where T : YagomMarket.Entity {
            readCallCount += 1
            return UserProfile(vendorName: "wongbing",
                               email: "test@naver.com",
                               likedProductIds: [10,12,14]) as! T
        }
        
        func update<T>(collectionId: String,
                       documentId: String,
                       to entity: T) async throws where T : YagomMarket.Entity {
            updateCallCount += 1
        }
        
        func delete(collectionId: String,
                    documentId: String) async throws {}
    }
    
    func test_UseCase가실행될때_FirestoreService의read와update메서드가실행된다() async throws {
        // given
        let expectationReadCallCount = 1
        let expectationUpdateCallCount = 1
        let firestoreService = FirestoreServiceMock<UserProfile>()
        let useCase = HandleLikedProductUseCase(firestoreService: firestoreService)
        
        // when
        _ = try await useCase.execute(with: 12, isAdd: true)
        
        // then
        XCTAssertEqual(expectationReadCallCount, firestoreService.readCallCount)
        XCTAssertEqual(expectationUpdateCallCount, firestoreService.updateCallCount)
    }
}
