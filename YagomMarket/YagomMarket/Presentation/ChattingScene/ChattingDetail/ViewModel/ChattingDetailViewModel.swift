//
//  ChattingDetailViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/09.
//

import Foundation

protocol ChattingDetailViewModelInput {
    func fetchMessages() async throws
    func sendMessage(body: String) async throws
}

protocol ChattingDetailViewModelOutput {
    var messages: [Message] { get }
}

protocol ChattingDetailViewModel: ChattingDetailViewModelInput, ChattingDetailViewModelOutput {}

final class DefaultChattingDetailViewModel: ChattingDetailViewModel {
    private(set) var messages: [Message] = []
    private let chattingUUID: String
    
    private let searchChattingUseCase: SearchChattingUseCase
    private let sendMessageUseCase: SendMessageUseCase
    
    init(
        chattingUUID: String,
        searchChattingUseCase: SearchChattingUseCase,
        sendMessageUseCase: SendMessageUseCase
    ) {
        self.chattingUUID = chattingUUID
        self.searchChattingUseCase = searchChattingUseCase
        self.sendMessageUseCase = sendMessageUseCase
    }
    
    func fetchMessages() async throws {
        messages = try await searchChattingUseCase.execute(with: chattingUUID)
    }
    
    func sendMessage(body: String) async throws {
        
        guard let vendorName = LoginCacheManager.fetchPreviousInfo()?.vendorName else {
            return
        }
        let message = Message(
            body: body,
            sender: vendorName,
            time: DateCalculator.shared.currentTime()
        )
        try await sendMessageUseCase.execute(
            chattingUUID: chattingUUID,
            message: message
        )
        try await fetchMessages()
    }
}
