//
//  SearchSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class SearchSceneDIContainer {
    private let modalSceneDIContainer = ModalSceneDIContainer()
    
    // MARK: - Search
    func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController {
        let viewModel = makeSearchViewModel(actions: actions)
        return SearchViewController(with: viewModel)
    }
    
    func makeSearchViewModel(actions: SearchViewModelActions) -> SearchViewModel {
        return DefaultSearchViewModel(
            actions: actions,
            searchQueryUseCase: makeSearchQueryUseCase(),
            searchQueryResultsUseCase: makeSearchQueryResultsUseCase()
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
        productId: Int,
                                         actions: ProductDetailViewModelActions
    ) -> ProductDetailViewController {
        
        let viewModel = makeProductDetailViewModel(
            productId: productId,
            actions: actions
        )
        return ProductDetailViewController(viewModel: viewModel )
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
            productId: productId
        )
    }
    
    // MARK: - UseCase
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
    
    func makeSearchQueryUseCase() -> SearchQueryUseCase {
        return DefaultSearchQueryUseCase(
            productsRepository: makeProductsRepository()
        )
    }
    
    func makeSearchQueryResultsUseCase() -> SearchQueryResultsUseCase {
        return DefaultSearchQueryResultsUseCase(
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
    
    // MARK: - Search Flow Coordinator
    func makeSearchFlowCoordinator(
        navigationController: UINavigationController
    ) -> SearchFlowCoordinator {
        
        return SearchFlowCoordinator(
            navCon: navigationController,
            dependencies: self
        )
    }
    
    // MARK: - Modal Flow Coordinator
    func makeModalFlowCoordinator(
        navigationController: UINavigationController
    ) -> ModalFlowCoordinator {
        return modalSceneDIContainer.makeModalFlowCoordinator(
            navigationController: navigationController
        )
    }
}

extension SearchSceneDIContainer: SearchFlowCoordinatorDependencies {}
