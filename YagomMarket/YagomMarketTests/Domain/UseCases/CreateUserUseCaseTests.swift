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
    
    struct DummyEntity: Entity {
        let name: String
        
        func toDictionary() -> Dictionary<String, Any> {
            return ["name": name]
        }
        
        func toEntity(with documentSnapshot: DocumentSnapshot) -> CreateUserUseCaseTests.DummyEntity {
            return self
        }
    }

    class FirebaseAuthServiceMock: FirebaseAuthService {
        var createUserCallCount = 0
        var signInCallCount = 0
        
        func createUser(email: String,
                        password: String) async throws -> AuthDataResult? {
            
            createUserCallCount += 1

            return nil
        }
        
        func signIn(email: String,
                    password: String) async throws -> AuthDataResult? {
            
            signInCallCount += 1
            
            return nil
        }
    }
    
    class FirestoreServiceMock<E: Entity>: FirestoreService {
        typealias T = E
        var firestore: [Entity] = []
        var createCallCount = 0
        
        func create<T>(collectionId: String,
                       documentId: String,
                       entity: T) async throws where T : YagomMarket.Entity {
            firestore.append(entity)
            createCallCount += 1
        }
        
        func read<T>(collectionId: String,
                     documentId: String,
                     entity: T) async throws -> T where T : YagomMarket.Entity {
            return DummyEntity(name: "") as! T
        }
        
        func update<T>(collectionId: String,
                       documentId: String, to entity: T) async throws where T : YagomMarket.Entity {}
        
        func delete(collectionId: String,
                    documentId: String) async throws {}
    }
    
    func test_UseCase를실행할때_FirebaseAuthService의_createUser메서드와_FirestoreService의_create메서드가실행되는지() async throws {
        // given
        let expectationCreateUserCallCount = 1
        let expectationCreateCallCount = 1
        let firebaseAuthService = FirebaseAuthServiceMock()
        let firestoreService = FirestoreServiceMock<DummyEntity>()
        let useCase = CreateUserUseCase(
            firebaseAuthService: firebaseAuthService,
            firestoreService: firestoreService
        )
        
        // when
        _ = try await useCase.execute(with: LoginInfo(id: "testId", password: "testPassword", vendorName: ""))
        
        // then
        XCTAssertEqual(expectationCreateUserCallCount, firebaseAuthService.createUserCallCount)
        XCTAssertEqual(expectationCreateCallCount, firestoreService.createCallCount)
    }
}
