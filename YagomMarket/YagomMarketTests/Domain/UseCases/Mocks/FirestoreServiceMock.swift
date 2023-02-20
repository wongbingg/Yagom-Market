//
//  FirestoreServiceMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import Foundation
import FirebaseFirestore
@testable import YagomMarket

struct DummyEntity: Entity {
    let name: String
    
    func toDictionary() -> Dictionary<String, Any> {
        return ["name": name]
    }
    
    static func toEntity(with documentSnapshot: DocumentSnapshot) -> DummyEntity {
        return DummyEntity(name: "")
    }
}

final class FirestoreServiceMock: FirestoreService {
    typealias T = DummyEntity
    
    var firestore: [Entity] = []
    var createCallCount = 0
    var readCallCount = 0
    var updateCallCount = 0
    
    func create<T>(collectionId: String,
                   documentId: String,
                   entity: T) async throws where T : YagomMarket.Entity {
        firestore.append(entity)
        createCallCount += 1
    }

    func read(collectionId: String,
                 documentId: String) async throws -> T {

        readCallCount += 1

        return DummyEntity(name: "")
    }
    
    func readDocuments(collectionId: String) async throws -> [DummyEntity] {
        return [DummyEntity(name: "")]
    }

    func update<T>(collectionId: String,
                   documentId: String, to entity: T) async throws where T : YagomMarket.Entity {
        updateCallCount += 1
    }

    func delete(collectionId: String,
                documentId: String) async throws {}
}

final class UserProfileFirestoreServiceMock: FirestoreService {
    typealias T = UserProfile
    var firestore: [Entity] = []
    var createCallCount = 0
    var readCallCount = 0
    var updateCallCount = 0
    var deleteCallCount = 0
    
    func create<T>(collectionId: String,
                   documentId: String,
                   entity: T) async throws where T : YagomMarket.Entity {
        firestore.append(entity)
        createCallCount += 1
    }

    func read(collectionId: String,
                 documentId: String) async throws -> T {

        readCallCount += 1

        return UserProfile.stub(chattingUUIDList: ["chattingUUID"])
    }
    
    func readDocuments(collectionId: String) async throws -> [T] {
        return [UserProfile.stub()]
    }

    func update<T>(collectionId: String,
                   documentId: String, to entity: T) async throws where T : YagomMarket.Entity {
        updateCallCount += 1
    }

    func delete(collectionId: String,
                documentId: String) async throws {
        deleteCallCount += 1
    }
}

final class UserUIDFirestoreServiceMock: FirestoreService {
    typealias T = UserUID
    var readCallCount = 0
    var createCallCount = 0
    
    func create<T>(collectionId: String,
                   documentId: String,
                   entity: T) async throws where T : Entity {
        createCallCount += 1
    }
    
    func read(collectionId: String,
              documentId: String) async throws -> UserUID {
        readCallCount += 1
        return UserUID.stub()
    }
    
    func readDocuments(collectionId: String) async throws -> [UserUID] {
        return [UserUID.stub()]
    }
    
    func update<T>(collectionId: String,
                   documentId: String,
                   to entity: T) async throws where T : Entity {
        //
    }
    
    func delete(collectionId: String,
                documentId: String) async throws {
        //
    }
}

final class MessageFirestoreServiceMock: FirestoreService {
    typealias T = Message
    var readCallCount = 0
    var readDocumentsCallCount = 0
    var createCallCount = 0
    
    func create<T>(collectionId: String,
                   documentId: String,
                   entity: T) async throws where T : Entity {
        createCallCount += 1
    }
    
    func read(collectionId: String,
              documentId: String) async throws -> Message {
        readCallCount += 1
        return Message.stub()
    }
    
    func readDocuments(collectionId: String) async throws -> [Message] {
        readDocumentsCallCount += 1
        return [Message.stub()]
    }
    
    func update<T>(collectionId: String,
                   documentId: String,
                   to entity: T) async throws where T : Entity {
        //
    }
    
    func delete(collectionId: String,
                documentId: String) async throws {
        //
    }
}
