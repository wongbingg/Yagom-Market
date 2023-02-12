//
//  ChattingSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

final class ChattingSceneDIContainer {
    private let modalSceneDIContainer = ModalSceneDIContainer()
    private let searchSceneDIContainer = SearchSceneDIContainer()
    
    // MARK: - Chatting List
    func makeChattingListViewController(
        actions: ChattingListViewModelActions) -> ChattingListViewController {
            
        let viewModel = makeChatViewModel(actions: actions)
        return ChattingListViewController(with: viewModel)
    }
    
    func makeChatViewModel(actions: ChattingListViewModelActions) -> ChattingListViewModel {
        return DefaultChattingListViewModel(
            actions: actions,
            searchUserProfileUseCase: makeSearchUserProfileUseCase(),
            searchChattingUseCase: makeSearchChattingUseCase()
        )
    }
    
    // MARK: - Chatting Detail
    func makeChattingDetailViewController(chattingUUID: String) -> ChattingDetailViewController {
        let viewModel = makeChattingDetailViewModel(chattingUUID: chattingUUID)
        return ChattingDetailViewController(viewModel: viewModel)
    }

    func makeChattingDetailViewModel(chattingUUID: String) -> ChattingDetailViewModel {
        return DefaultChattingDetailViewModel(
            chattingUUID: chattingUUID,
            searchChattingUseCase: makeSearchChattingUseCase(),
            sendMessageUseCase: makeSendMessageUseCase()
        )
    }
    
    // MARK: - Modal View
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController {
        let viewModel = makeRegisterViewModel(model: model, actions: actions)
        return RegisterViewController(with: viewModel)
    }
    
    func makeRegisterViewModel(model: ProductDetail?,
                               actions: RegisterViewModelActions) -> RegisterViewModel {
        return DefaultRegisterViewModel(model: model, actions: actions)
    }
    
    // MARK: - UseCase
    func makeSearchUserProfileUseCase() -> SearchUserProfileUseCase {
        return DefaultSearchUserProfileUseCase(
            firestoreService: makeUserProfileFirestoreService()
        )
    }
    
    func makeSearchChattingUseCase() -> SearchChattingUseCase {
        return DefaultSearchChattingUseCase(
            firestoreService: makeMessageFirestoreService()
        )
    }
    
    func makeSendMessageUseCase() -> SendMessageUseCase {
        return DefaultSendMessageUseCase(
            firestoreService: makeMessageFirestoreService()
        )
    }
    
    // MARK: - Services
    func makeUserProfileFirestoreService() -> DefaultFirestoreService<UserProfile> {
        return DefaultFirestoreService<UserProfile>()
    }
    
    func makeMessageFirestoreService() -> DefaultFirestoreService<Message> {
        return DefaultFirestoreService<Message>()
    }
    
    // MARK: - Chatting Flow Coordinator
    func makeChattingFlowCoordinator(
        navigationController: UINavigationController) -> ChattingFlowCoordinator {
        
        return ChattingFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }

    // MARK: - Search Flow Coordinator
    func makeSearchFlowCoordinator(
        navigationController: UINavigationController) -> SearchFlowCoordinator {
            
        return searchSceneDIContainer.makeSearchFlowCoordinator(
            navigationController: navigationController
        )
    }
    
    // MARK: - Modal Flow Coordinator
    func makeModalFlowCoordinator(
        navigationController: UINavigationController) -> ModalFlowCoordinator {
            
        return modalSceneDIContainer.makeModalFlowCoordinator(
            navigationController: navigationController
        )
    }
}

extension ChattingSceneDIContainer: ChattingFlowCoordinatorDependencies {}
