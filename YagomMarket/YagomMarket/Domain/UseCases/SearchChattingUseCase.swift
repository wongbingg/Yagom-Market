//
//  SearchChattingUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/08.
//

import Foundation

protocol SearchChattingUseCase {
    func execute(with uuid: String) async throws -> [Message]
}

final class DefaultSearchChattingUseCase: SearchChattingUseCase {
    private let firestoreService: any FirestoreService
    
    init(firestoreService: any FirestoreService) {
        self.firestoreService = firestoreService
    }
    
    func execute(with uuid: String) async throws -> [Message] {
        let response = try await firestoreService.readDocuments(
            collectionId: uuid
        )
        
        return response as! [Message]
    }
}
