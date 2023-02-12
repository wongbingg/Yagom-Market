//
//  MyPageSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

final class MyPageSceneDIContainer {
    private let modalSceneDIContainer = ModalSceneDIContainer()
    private let searchSceneDIContainer = SearchSceneDIContainer()
    
    // MARK: - MyPage
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController {
        let viewModel = makeMyPageViewModel(actions: actions)
        return MyPageViewController(with: viewModel)
    }
    
    func makeMyPageViewModel(actions: MyPageViewModelActions) -> MyPageViewModel {
        return DefaultMyPageViewModel(
            actions: actions,
            searchQueryResultsUseCase: makeSearchQueryResultsUseCase(),
            searchUserProfileUseCase: makeSearchUserProfileUseCase(),
            fetchProductDetailUseCase: makeFetchProductDetailUseCase()
        )
    }
    
    // MARK: - Result
    func makeResultViewController(cells: [ProductCell],
                                  actions: ResultViewModelAction) -> ResultViewController {
        let viewModel = makeResultViewModel(model: cells, actions: actions)
        return ResultViewController(viewModel: viewModel)
    }
    
    func makeResultViewModel(model: [ProductCell],
                             actions: ResultViewModelAction) -> ResultViewModel {
        return DefaultResultViewModel(
            cells: model,
            actions: actions,
            handleLikedProductUseCase: makeHandleLikedProductUseCase(),
            searchUserProfileUseCase: makeSearchUserProfileUseCase()
        )
    }
    
    // MARK: - Product Detail
    func makeProductDetailViewController(
        productId: Int, actions: ProductDetailViewModelActions) -> ProductDetailViewController {
            
        let viewModel = makeProductDetailViewModel(productId: productId, actions: actions)
        return ProductDetailViewController(viewModel: viewModel)
    }
    
    func makeProductDetailViewModel(
        productId: Int, actions: ProductDetailViewModelActions) -> ProductDetailViewModel {
            
        return DefaultProductDetailViewModel(
            actions: actions,
            deleteProductUseCase: makeDeleteProductUseCase(),
            fetchProductDetailUseCase: makeFetchProductDetailUseCase(),
            searchUserProfileUseCase: makeSearchUserProfileUseCase(),
            handleLikedProductUseCase: makeHandleLikedProductUseCase(),
            handleChattingUseCase: makeHandleChattingUseCase(),
            searchOthersUIDUseCase: makeSearchOthersUIDUseCase(),
            productId: productId
        )
    }
    
    // MARK: - UseCase
    func makeDeleteProductUseCase() -> DeleteProductUseCase {
        return DefaultDeleteProductUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeFetchProductDetailUseCase() -> FetchProductDetailUseCase {
        return DefaultFetchProductDetailUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeSearchQueryResultsUseCase() -> SearchQueryResultsUseCase {
        return DefaultSearchQueryResultsUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeSearchUserProfileUseCase() -> SearchUserProfileUseCase {
        DefaultSearchUserProfileUseCase(firestoreService: makeFirestoreService())
    }
    
    func makeHandleLikedProductUseCase() -> HandleLikedProductUseCase {
        return DefaultHandleLikedProductUseCase(
            firestoreService: makeFirestoreService()
        )
    }
    
    func makeSearchOthersUIDUseCase() -> SearchOthersUIDUseCase {
        return DefaultSearchOthersUIDUseCase(
            firestoreService: makeFirestoreService()
        )
    }
    
    func makeHandleChattingUseCase() -> HandleChattingUseCase {
        return DefaultHandleChattingUseCase(
            firestoreService: makeChattingFirestoreService()
        )
    }
    
    // MARK: - Repositories
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository()
    }
    
    // MARK: - Services
    func makeFirestoreService() -> DefaultFirestoreService<UserProfile> {
        return DefaultFirestoreService<UserProfile>()
    }
    
    func makeChattingFirestoreService() -> DefaultFirestoreService<Message> {
        return DefaultFirestoreService<Message>()
    }
    
    // MARK: - MyPage Flow Coordinator
    func makeMyPageFlowCoordinator(
        navigationController: UINavigationController) -> MyPageFlowCoordinator {
        
        return MyPageFlowCoordinator(
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

extension MyPageSceneDIContainer: MyPageFlowCoordinatorDependencies {}
