//
//  ChattingListViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

struct ChattingListViewModelActions {
    let registerTapSelected: () -> Void
    let searchTapSelected: () -> Void
}

protocol ChattingListViewModelInput {
    func fetchChattingList() async throws
    func searchTapSelected()
    func registerTapSelected()
    func didSelectRowAt()
}

protocol ChattingListViewModelOutput {
    var chattingCells: [ChattingCell] { get }
}

protocol ChattingListViewModel: ChattingListViewModelInput, ChattingListViewModelOutput {}

final class DefaultChattingListViewModel: ChattingListViewModel {
    private let actions: ChattingListViewModelActions
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    private let searchChattingUseCase: SearchChattingUseCase
    private(set) var chattingCells: [ChattingCell] = [ChattingCell(buddyId: "123@naver.com", lastMessage: "안녕하세요"),
                                                      ChattingCell(buddyId: "111@naver.com", lastMessage: "이거 얼마인가요"),
                                                      ChattingCell(buddyId: "222@naver.com", lastMessage: "네고가능한가요")]
    init(
        actions: ChattingListViewModelActions,
        searchUserProfileUseCase: SearchUserProfileUseCase,
        searchChattingUseCase: SearchChattingUseCase
    ) {
        self.actions = actions
        self.searchUserProfileUseCase = searchUserProfileUseCase
        self.searchChattingUseCase = searchChattingUseCase
    }
    
    func fetchChattingList() async throws {
        var chattings = [ChattingCell]()
        let userProfile = try await searchUserProfileUseCase.execute(othersUID: nil)
        for chattingUUID in userProfile.chattingUUIDList {
            let buddyId = try await pickBuddyEmail(in: chattingUUID)
            let response = try await searchChattingUseCase.execute(with: chattingUUID)
            let lastMessage = response.last?.body ?? "대화가 없습니다."
            chattings.append(ChattingCell(buddyId: buddyId, lastMessage: lastMessage))
        }
        chattingCells = chattings
    }
    
    func didSelectRowAt() {
        
    }
    
    func searchTapSelected() {
        actions.searchTapSelected()
    }
    
    func registerTapSelected() {
        actions.registerTapSelected()
    }
    
    private func pickBuddyEmail(in chattingUUID: String) async throws -> String {
        // buddyUID%userUID%UUID
        var uuidArr = chattingUUID.split(separator: "%")
        uuidArr.removeLast()
        let myUID = LoginCacheManager.fetchPreviousInfo()!.userUID
        let buddyUID = String(uuidArr.filter { $0 != myUID }[0])
        let buddyProfile = try await searchUserProfileUseCase.execute(othersUID: buddyUID)
        let buddyEmail = buddyProfile.email
        return buddyEmail
    }
}
