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
    
    class FirestoreServiceMock<E: Entity>: FirestoreService {
        typealias T = E
        var firestore: [Entity] = []
        var readCallCount = 0
        
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
                       to entity: T) async throws where T : YagomMarket.Entity {}
        
        func delete(collectionId: String,
                    documentId: String) async throws {}
    }
    
    func test_UseCase실행시_FirestoreService의read가실행되는지() async throws {
        // given
        let expectationReadCallCount = 1
        let firestoreService = FirestoreServiceMock<UserProfile>()
        let useCase = SearchUserProfileUseCase(firestoreService: firestoreService)
        
        // when
        _ = try await useCase.execute()
        
        // then
        XCTAssertEqual(expectationReadCallCount, firestoreService.readCallCount)
    }
}
