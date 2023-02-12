//
//  ChattingListViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

struct ChattingListViewModelActions {
    let registerTapSelected: () -> Void
    let searchTapSelected: () -> Void
    let chattingCellTapped: (String) -> Void
}

protocol ChattingListViewModelInput {
    func fetchChattingList() async throws
    func searchTapSelected()
    func registerTapSelected()
    func didSelectRowAt(index: Int)
}

protocol ChattingListViewModelOutput {
    var chattingCells: [ChattingCell] { get }
}

protocol ChattingListViewModel: ChattingListViewModelInput, ChattingListViewModelOutput {}

final class DefaultChattingListViewModel: ChattingListViewModel {
    private let actions: ChattingListViewModelActions
    private let searchUserProfileUseCase: SearchUserProfileUseCase
    private let searchChattingUseCase: SearchChattingUseCase
    private var userProfile: UserProfile = UserProfile.stub()
    private(set) var chattingCells: [ChattingCell] = []
    
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
        userProfile = try await searchUserProfileUseCase.execute(othersUID: nil)
        for chattingUUID in userProfile.chattingUUIDList {
            let buddyId = try await picksellerVendorName(in: chattingUUID)
            let response = try await searchChattingUseCase.execute(with: chattingUUID)
            let lastMessage = response.last?.body ?? "대화가 없습니다."
            chattings.append(ChattingCell(buddyId: buddyId, lastMessage: lastMessage))
        }
        chattingCells = chattings
    }
    
    func didSelectRowAt(index: Int) {
        let chattingUUID = userProfile.chattingUUIDList[index]
        actions.chattingCellTapped(chattingUUID)
    }
    
    func searchTapSelected() {
        actions.searchTapSelected()
    }
    
    func registerTapSelected() {
        actions.registerTapSelected()
    }
    
    private func picksellerVendorName(in chattingUUID: String) async throws -> String {
        var uuidArr = chattingUUID.split(separator: "%")
        uuidArr.removeLast()
        let myVendorName = LoginCacheManager.fetchPreviousInfo()!.vendorName
        let sellerVendorName = String(uuidArr.filter { $0 != myVendorName }[0])
        return sellerVendorName
    }
}
