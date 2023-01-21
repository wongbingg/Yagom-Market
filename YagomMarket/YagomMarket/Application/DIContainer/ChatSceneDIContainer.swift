//
//  ChatSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import Foundation

final class ChatSceneDIContainer {
    // MARK: - Chat
    func makeChatViewController(actions: ChatViewModelActions) -> ChatViewController {
        let viewModel = makeChatViewModel(actions: actions)
        return ChatViewController(with: viewModel)
    }
    
    func makeChatViewModel(actions: ChatViewModelActions) -> ChatViewModel {
        return DefaultChatViewModel(actions: actions)
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
    func makeChatFlowCoordinator() -> ChatFlowCoordinator {
        
        return ChatFlowCoordinator(dependencies: self)
    }
    
    // Test
//    func makeChatFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
//
//        return ChatFlowCoordinator(navCon: navigationController, dependencies: self)
//    }
}

extension ChatSceneDIContainer: ChatFlowCoordinatorDependencies {}
