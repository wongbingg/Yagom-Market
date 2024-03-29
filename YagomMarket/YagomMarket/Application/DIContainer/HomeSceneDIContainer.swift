//
//  HomeSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class HomeSceneDIContainer {
    private let modalSceneDIContainer = ModalSceneDIContainer()
    private let searchSceneDIContainer = SearchSceneDIContainer()
    private let chattingSceneDIContainer = ChattingSceneDIContainer()
    
    // MARK: - Product List
    func makeProductListViewController(
        actions: ProductListViewModelActions
    ) -> ProductListViewController {
        
        let viewModel = makeProductListViewModel(actions: actions)
        return ProductListViewController(with: viewModel)
    }
    
    func makeProductListViewModel(
        actions: ProductListViewModelActions
    ) -> ProductListViewModel {
        
        return DefaultProductListViewModel(
            actions: actions,
            addNextProductPageUseCase: makeAddNextProductPageUseCase(),
            handleLikedProductUseCase: makeHandleLikedProductUseCase(),
            searchUserProfileUseCase: makeSearchUserProfileUseCase()
        )
    }
    
    // MARK: - Product Detail
    func makeProductDetailViewController(
        productId: Int,
        actions: ProductDetailViewModelActions
    ) -> ProductDetailViewController {
        
        let viewModel = makeProductDetailViewModel(
            productId: productId,
            actions: actions
        )
        return ProductDetailViewController(
            viewModel: viewModel
        )
    }
    
    func makeProductDetailViewModel(
        productId: Int,
        actions: ProductDetailViewModelActions
    ) -> ProductDetailViewModel {
        
        return DefaultProductDetailViewModel(
            actions: actions,
            deleteProductUseCase: makeDeleteProductUseCase(),
            fetchProductDetailUseCase: makeFetchProductDetailUseCase(),
            searchUserProfileUseCase: makeSearchUserProfileUseCase(),
            handleLikedProductUseCase: makeHandleLikedProductUseCase(),
            handleChattingUseCase: makeHandleChattingUseCase(),
            searchOthersUIDUseCase: makeSearchOthersUIDUseCase(),
            productId: productId)
    }
    
    // MARK: - UseCase
    func makeAddNextProductPageUseCase() -> AddNextProductPageUseCase {
        return DefaultAddNextProductPageUseCase(
            productsRepository: makeProductsRepository()
        )
    }
    
    func makeDeleteProductUseCase() -> DeleteProductUseCase {
        return DefaultDeleteProductUseCase(
            productsRepository: makeProductsRepository()
        )
    }
    
    func makeFetchProductDetailUseCase() -> FetchProductDetailUseCase {
        return DefaultFetchProductDetailUseCase(
            productsRepository: makeProductsRepository()
        )
    }
    
    func makeSearchUserProfileUseCase() -> SearchUserProfileUseCase {
        return DefaultSearchUserProfileUseCase(
            firestoreService: makeFirestoreService()
        )
    }
    
    func makeHandleLikedProductUseCase() -> HandleLikedProductUseCase {
        return DefaultHandleLikedProductUseCase(
            firestoreService: makeFirestoreService()
        )
    }
    
    func makeHandleChattingUseCase() -> HandleChattingUseCase {
        return DefaultHandleChattingUseCase(
            firestoreService: makeFirestoreService()
        )
    }
    
    func makeSearchOthersUIDUseCase() -> SearchOthersUIDUseCase {
        return DefaultSearchOthersUIDUseCase(
            firestoreService: makeOthersUIDFirestoreService()
        )
    }
    
    // MARK: - Repositories
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository()
    }
    
    func makeImageRepository() -> ImageRepository {
        return DefaultImageRepository(
            imageCacheManager: DefaultImageCacheManager()
        )
    }
    
    func makeFirestoreService() -> DefaultFirestoreService<UserProfile> {
        return DefaultFirestoreService<UserProfile>()
    }
    
    func makeChattingFirestoreService() -> DefaultFirestoreService<Message> {
        return DefaultFirestoreService<Message>()
    }
    
    func makeOthersUIDFirestoreService() -> DefaultFirestoreService<UserUID> {
        return DefaultFirestoreService<UserUID>()
    }
    
    // MARK: - Home Flow Coordinator
    func makeHomeFlowCoordinator(navigationController: UINavigationController,
                                 userUID: String) -> HomeFlowCoordinator {
        
        return HomeFlowCoordinator(userUID: userUID,
                                   navigationController: navigationController,
                                   dependencies: self)
    }
    
    // MARK: - Search Flow Coordinator
    func makeSearchFlowCoordinator(
        navigationController: UINavigationController) -> SearchFlowCoordinator {
        
        return searchSceneDIContainer.makeSearchFlowCoordinator(
            navigationController: navigationController
        )
    }
    
    // MARK: - Chatting Flow Coordinator
    func makeChattingFlowCoordinator(
        navigationController: UINavigationController) -> ChattingFlowCoordinator {
        
        return chattingSceneDIContainer.makeChattingFlowCoordinator(
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

extension HomeSceneDIContainer: HomeFlowCoordinatorDependencies {}
