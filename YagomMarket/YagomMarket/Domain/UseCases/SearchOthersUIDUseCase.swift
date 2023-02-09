//
//  SearchOthersUIDUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/08.
//

protocol SearchOthersUIDUseCase {
    func execute(with vendorName: String) async throws -> UserUID
}

final class DefaultSearchOthersUIDUseCase: SearchOthersUIDUseCase {
    private let firestoreService: any FirestoreService
    
    init(firestoreService: any FirestoreService) {
        self.firestoreService = firestoreService
    }
    
    func execute(with vendorName: String) async throws -> UserUID {
        let response = try await firestoreService.read(
            collectionId: "vendorNameToUserUID",
            documentId: vendorName
        )
        
        return response as! UserUID
    }
}
