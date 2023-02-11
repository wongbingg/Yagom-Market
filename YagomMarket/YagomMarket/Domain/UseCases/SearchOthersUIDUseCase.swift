//
//  SearchOthersUIDUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/08.
//

import Foundation

protocol SearchOthersUIDUseCase {
    func execute(with vendorName: String) async throws -> UserUID
}

final class DefaultSearchOthersUIDUseCase: SearchOthersUIDUseCase {
    
    private enum SearchError: LocalizedError {
        case failToFindUser
        
        var errorDescription: String? {
            switch self {
            case .failToFindUser:
                return "가입되지 않은 사용자 입니다."
            }
        }
    }
    
    private let firestoreService: any FirestoreService
    
    init(firestoreService: any FirestoreService) {
        self.firestoreService = firestoreService
    }
    
    func execute(with vendorName: String) async throws -> UserUID {
        do {
            let response = try await firestoreService.read(
                collectionId: "vendorNameToUserUID",
                documentId: vendorName
            )
            return response as! UserUID
        } catch {
            throw SearchError.failToFindUser
        }
    }
}
