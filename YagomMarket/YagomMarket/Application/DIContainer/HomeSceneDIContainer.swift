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
        return DefaultProductListViewModel(actions: actions)
    }
    
    // MARK: - Product Detail
    func makeProductDetailViewController(productId: Int, actions: ProductDetailViewModelActions) -> ProductDetailViewController {
        let viewModel = makeProductDetailViewModel(productId: productId, actions: actions)
        return ProductDetailViewController(viewModel: viewModel)
    }
    
    func makeProductDetailViewModel(productId: Int,
                                    actions: ProductDetailViewModelActions) -> ProductDetailViewModel {
        return DefaultProductDetailViewModel(actions: actions, productId: productId)
    }
    
    // MARK: - Search
    func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController {
        let viewModel = makeSearchViewModel(actions: actions)
        return SearchViewController(with: viewModel)
    }
    
    func makeSearchViewModel(actions: SearchViewModelActions) -> SearchViewModel {
        return DefaultSearchViewModel(actions: actions)
    }
    
    // MARK: - Modal View
    func makeRegisterViewController(model: ProductDetail?, actions: RegisterViewModelActions) -> RegisterViewController {
        let viewModel = makeRegisterViewModel(model: model, actions: actions)
        return RegisterViewController(with: viewModel)
    }
    
    func makeRegisterViewModel(model: ProductDetail?, actions: RegisterViewModelActions) -> RegisterViewModel {
        return DefaultRegisterViewModel(model: model, actions: actions)
    }
    
    func makeImageViewerController(imageURLs: [String], currentPage: Int) -> ImageViewerViewController {
        return ImageViewerViewController(imageURLs: imageURLs, currentPage: currentPage)
    }
    
    // MARK: - UseCase
    
    // MARK: - Home Flow Coordinator
    func makeHomeFlowCoordinator(fireStoreCollectionId: String) -> HomeFlowCoordinator {
        
        return HomeFlowCoordinator(dependencies: self)
    }
}

extension HomeSceneDIContainer: HomeFlowCoordinatorDependencies {}
