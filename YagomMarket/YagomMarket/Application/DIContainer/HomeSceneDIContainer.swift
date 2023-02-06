//
//  HomeSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class HomeSceneDIContainer {
    // MARK: - Product List
    func makeProductListViewController(actions: ProductListViewModelActions) -> ProductListViewController {
        let viewModel = makeProductListViewModel(actions: actions)
        return ProductListViewController(with: viewModel)
    }
    
    func makeProductListViewModel(actions: ProductListViewModelActions) -> ProductListViewModel {
        return DefaultProductListViewModel(
            actions: actions,
            addNextProductPageUseCase: makeAddNextProductPageUseCase()
        )
    }
    
    // MARK: - Product Detail
    func makeProductDetailViewController(productId: Int,
                                         actions: ProductDetailViewModelActions) -> ProductDetailViewController {
        let viewModel = makeProductDetailViewModel(productId: productId, actions: actions)
        return ProductDetailViewController(
            viewModel: viewModel
        )
    }
    
    func makeProductDetailViewModel(productId: Int,
                                    actions: ProductDetailViewModelActions) -> ProductDetailViewModel {
        return DefaultProductDetailViewModel(
            actions: actions,
            deleteProductUseCase: makeDeleteProductUseCase(),
            fetchProductDetailUseCase: makeFetchProductDetailUseCase(),
            searchUserProfileUseCase: makeSearchUserProfileUseCase(),
            handleLikedProductUseCase: makeHandleLikedProductUseCase(),
            productId: productId)
    }
    
    // MARK: - Modal View
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController {
        let viewModel = makeRegisterViewModel(model: model, actions: actions)
        return RegisterViewController(with: viewModel)
    }
    
    func makeRegisterViewModel(model: ProductDetail?,
                               actions: RegisterViewModelActions) -> RegisterViewModel {
        return DefaultRegisterViewModel(
            model: model,
            actions: actions,
            registerProductUseCase: makeRegisterProductUseCase(),
            editProductUseCase: makeEditProductUseCase()
        )
    }
    
    func makeImageViewerController(imageURLs: [String],
                                   currentPage: Int) -> ImageViewerViewController {
        return ImageViewerViewController(
            imageURLs: imageURLs,
            currentPage: currentPage
        )
    }
    
    // MARK: - UseCase
    func makeAddNextProductPageUseCase() -> AddNextProductPageUseCase {
        return DefaultAddNextProductPageUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeDeleteProductUseCase() -> DeleteProductUseCase {
        return DefaultDeleteProductUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeFetchProductDetailUseCase() -> FetchProductDetailUseCase {
        return DefaultFetchProductDetailUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeSearchUserProfileUseCase() -> SearchUserProfileUseCase {
        return DefaultSearchUserProfileUseCase(firestoreService: makeFirestoreService())
    }
    
    func makeHandleLikedProductUseCase() -> HandleLikedProductUseCase {
        return DefaultHandleLikedProductUseCase(firestoreService: makeFirestoreService())
    }
    
    func makeRegisterProductUseCase() -> RegisterProductUseCase {
        return DefaultRegisterProductUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeEditProductUseCase() -> EditProductUseCase {
        return DefaultEditProductUseCase(productsRepository: makeProductsRepository())
    }
    
    
    // MARK: - Repositories
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository()
    }
    
    func makeImageRepository() -> ImageRepository {
        return DefaultImageRepository(imageCacheManager: DefaultImageCacheManager())
    }
    
    func makeFirestoreService() -> DefaultFirestoreService<UserProfile> {
        return DefaultFirestoreService<UserProfile>()
    }
    
    // MARK: - Home Flow Coordinator
    func makeHomeFlowCoordinator(navigationController: UINavigationController,
                                 userUID: String) -> HomeFlowCoordinator {
        
        return HomeFlowCoordinator(userUID: userUID,
                                   navigationController: navigationController,
                                   dependencies: self)
    }
}

extension HomeSceneDIContainer: HomeFlowCoordinatorDependencies {}
