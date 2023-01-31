//
//  MyPageSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

final class MyPageSceneDIContainer {
    // MARK: - MyPage
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController {
        let viewModel = makeMyPageViewModel(actions: actions)
        return MyPageViewController(with: viewModel)
    }
    
    func makeMyPageViewModel(actions: MyPageViewModelActions) -> MyPageViewModel {
        return DefaultMyPageViewModel(
            actions: actions,
            searchQueryResultsUseCase: makeSearchQueryResultsUseCase(),
            searchUserProfileUseCase: makeSearchUserProfileUseCase()
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
    
    // MARK: - Result
    func makeResultViewController(model: ProductListResponseDTO,
                                  actions: ResultViewModelAction) -> ResultViewController {
        let viewModel = makeResultViewModel(model: model, actions: actions)
        return ResultViewController(viewModel: viewModel)
    }
    
    func makeResultViewModel(model: ProductListResponseDTO,
                             actions: ResultViewModelAction) -> ResultViewModel {
        return DefaultResultViewModel(model: model, actions: actions)
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
            productId: productId
        )
    }
    // MARK: - UseCase
    func makeDeleteProductUseCase() -> DeleteProductUseCase {
        return DeleteProductUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeFetchProductDetailUseCase() -> FetchProductDetailUseCase {
        return FetchProductDetailUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeSearchQueryResultsUseCase() -> SearchQueryResultsUseCase {
        return SearchQueryResultsUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeSearchUserProfileUseCase() -> SearchUserProfileUseCase {
        SearchUserProfileUseCase(firestoreService: makeFirestoreService())
    }
    
    // MARK: - Repositories
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository()
    }
    
    // MARK: - Services
    func makeFirestoreService() -> DefaultFirestoreService<UserProfile> {
        return DefaultFirestoreService<UserProfile>()
    }
    
    // MARK: - MyPage Flow Coordinator
    func makeMyPageFlowCoordinator(navigationController: UINavigationController) -> MyPageFlowCoordinator {
        
        return MyPageFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension MyPageSceneDIContainer: MyPageFlowCoordinatorDependencies {}
