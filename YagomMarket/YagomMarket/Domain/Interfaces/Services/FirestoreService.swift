//
//  FirestoreService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseCore
import FirebaseFirestore

protocol FirestoreService {
    associatedtype T

    func create<T: Entity>(collectionId: String, documentId: String, entity: T) async throws
    func read<T: Entity>(collectionId: String, documentId: String, entity: T) async throws -> T
    func update<T: Entity>(collectionId: String, documentId: String, to entity: T) async throws
    func delete(collectionId: String, documentId: String) async throws
}

enum FirestoreServiceError: LocalizedError {
    case failToCreate
    case failToRead
    case failToUpdate
    case failToDelete
    case noSuchId(Int)

    var errorDescription: String? {
        switch self {
        case .failToCreate:
            return "Firestore에 데이터를 생성하는데 실패했습니다."
        case .failToRead:
            return "Firestore에서 데이터를 읽어오는데 실패했습니다."
        case .failToUpdate:
            return "Firestore에 데이터를 업데이트 하는데 실패했습니다."
        case .failToDelete:
            return "Firestore에서 데이터를 삭제하는데 실패했습니다."
        case .noSuchId(let num):
            return "상품 아이디 \(num) 는 좋아요 목록에 없습니다."
        }
    }
}
