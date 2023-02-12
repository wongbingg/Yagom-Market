//
//  ChattingDetailViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/09.
//

import Foundation

protocol ChattingDetailViewModelInput {
    func fetchMessages() async throws
    func sendMessage(message: Message) async throws
}

protocol ChattingDetailViewModelOutput {
    var testModel: [Message] { get }
    var messages: [Message] { get }
}

protocol ChattingDetailViewModel: ChattingDetailViewModelInput, ChattingDetailViewModelOutput {}

final class DefaultChattingDetailViewModel: ChattingDetailViewModel {
    private(set) var messages: [Message] = []
    private let chattingUUID: String
    var testModel = [Message(body: "안녕하세요", sender: "bory", time: ""),
                     Message(body: "네 안녕하세요", sender: "derrick", time: ""),
                     Message(body: "물건관심있어 연락드려요", sender: "bory", time: ""),
                     Message(body: "네 얼마 생각하세요?", sender: "derrick", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: ""),
                     Message(body: "공짜여", sender: "bory", time: "")]
    
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
    
    func sendMessage(message: Message) async throws {
        try await sendMessageUseCase.execute(
            chattingUUID: chattingUUID,
            message: message
        )
    }
    
}
