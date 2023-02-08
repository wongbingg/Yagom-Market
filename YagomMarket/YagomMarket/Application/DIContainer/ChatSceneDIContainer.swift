//
//  ChatSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

final class ChatSceneDIContainer {
    private let modalSceneDIContainer = ModalSceneDIContainer()
    private let searchSceneDIContainer = SearchSceneDIContainer()
    
    // MARK: - Chat
    func makeChatViewController(actions: ChattingListViewModelActions) -> ChattingListViewController {
        let viewModel = makeChatViewModel(actions: actions)
        return ChattingListViewController(with: viewModel)
    }
    
    func makeChatViewModel(actions: ChattingListViewModelActions) -> ChattingListViewModel {
        return DefaultChattingListViewModel(actions: actions)
    }
    
    // MARK: - Chat Detail
//    func makeProductDetailViewController(productId: Int, actions: ProductDetailViewModelActions) -> ProductDetailViewController {
//        let viewModel = makeProductDetailViewModel(productId: productId, actions: actions)
//        return ProductDetailViewController(viewModel: viewModel)
//    }
//
//    func makeProductDetailViewModel(productId: Int,
//                                    actions: ProductDetailViewModelActions) -> ProductDetailViewModel {
//        return DefaultProductDetailViewModel(actions: actions, productId: productId)
//    }
    
    // MARK: - Modal View
    func makeRegisterViewController(model: ProductDetail?, actions: RegisterViewModelActions) -> RegisterViewController {
        let viewModel = makeRegisterViewModel(model: model, actions: actions)
        return RegisterViewController(with: viewModel)
    }
    
    func makeRegisterViewModel(model: ProductDetail?, actions: RegisterViewModelActions) -> RegisterViewModel {
        return DefaultRegisterViewModel(model: model, actions: actions)
    }
    // MARK: - UseCase
    
    // MARK: - Chat Flow Coordinator
    func makeChatFlowCoordinator(navigationController: UINavigationController) -> ChatFlowCoordinator {
        
        return ChatFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    // Test
//    func makeChatFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
//
//        return ChatFlowCoordinator(navCon: navigationController, dependencies: self)
//    }
    // MARK: - Search Flow Coordinator
    func makeSearchFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
        return searchSceneDIContainer.makeSearchFlowCoordinator(navigationController: navigationController)
    }
    
    // MARK: - Modal Flow Coordinator
    func makeModalFlowCoordinator(navigationController: UINavigationController) -> ModalFlowCoordinator {
        return modalSceneDIContainer.makeModalFlowCoordinator(navigationController: navigationController)
    }
}

extension ChatSceneDIContainer: ChatFlowCoordinatorDependencies {}
