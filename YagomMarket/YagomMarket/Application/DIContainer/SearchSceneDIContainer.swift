//
//  SearchSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class SearchSceneDIContainer {
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
        return DefaultResultViewModel(cells: model, actions: actions)
    }
    
    // MARK: - Product Detail
    func makeProductDetailViewController(productId: Int,
                                         actions: ProductDetailViewModelActions) -> ProductDetailViewController {
        let viewModel = makeProductDetailViewModel(productId: productId, actions: actions)
        return ProductDetailViewController(viewModel: viewModel )
    }
    
    func makeProductDetailViewModel(productId: Int,
                                    actions: ProductDetailViewModelActions) -> ProductDetailViewModel {
        return DefaultProductDetailViewModel(
            actions: actions,
            deleteProductUseCase: makeDeleteProductUseCase(),
            fetchProductDetailUseCase: makeFetchProductDetailUseCase(),
            searchUserProfileUseCase: makeSearchUserProfileUseCase(),
            handleLikedProductUseCase: makeHandleLikedProductUseCase(),
            productId: productId
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
    
    func makeImageViewerController(imageURLs: [String],
                                   currentPage: Int) -> ImageViewerViewController {
        return ImageViewerViewController(imageURLs: imageURLs, currentPage: currentPage)
    }
    // MARK: - UseCase
    func makeDeleteProductUseCase() -> DeleteProductUseCase {
        return DeleteProductUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeFetchProductDetailUseCase() -> FetchProductDetailUseCase {
        return FetchProductDetailUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeSearchQueryUseCase() -> SearchQueryUseCase {
        return SearchQueryUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeSearchQueryResultsUseCase() -> SearchQueryResultsUseCase {
        return SearchQueryResultsUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeSearchUserProfileUseCase() -> SearchUserProfileUseCase {
        return SearchUserProfileUseCase(firestoreService: makeFirestoreService())
    }
    
    func makeHandleLikedProductUseCase() -> HandleLikedProductUseCase {
        return HandleLikedProductUseCase(firestoreService: makeFirestoreService())
    }

    // MARK: - Repositories
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository()
    }
    
    // MARK: - Services
    func makeFirestoreService() -> DefaultFirestoreService<UserProfile> {
        return DefaultFirestoreService<UserProfile>()
    }
    
    // MARK: - Search Flow Coordinator
    func makeSearchFlowCoordinator() -> SearchFlowCoordinator {

        return SearchFlowCoordinator(dependencies: self)
    }
    
    // Test
    func makeSearchFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
        
        return SearchFlowCoordinator(
            navCon: navigationController,
            dependencies: self
        )
    }
}

extension SearchSceneDIContainer: SearchFlowCoordinatorDependencies {}
