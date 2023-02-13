//
//  SendMessageUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/12.
//

protocol SendMessageUseCase {
    func execute(chattingUUID: String,
                 message: Message) async throws
}

final class DefaultSendMessageUseCase: SendMessageUseCase {
    private let firestoreService: any FirestoreService
    
    init(
        firestoreService: any FirestoreService
    ) {
        self.firestoreService = firestoreService
    }
    
    func execute(chattingUUID: String, message: Message) async throws {
        
        try await firestoreService.create(
            collectionId: chattingUUID,
            documentId: message.time,
            entity: message
        )
    }
}
