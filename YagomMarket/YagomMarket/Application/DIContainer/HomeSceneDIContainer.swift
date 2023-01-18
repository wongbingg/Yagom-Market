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
    func makeProductDetailViewController(productId: Int) -> ProductDetailViewController {
        let viewModel = makeProductDetailViewModel()
        return ProductDetailViewController(productId: productId, viewModel: viewModel)
    }
    
    func makeProductDetailViewModel() -> ProductDetailViewModel {
        return DefaultProductDetailViewModel()
    }
    
    // MARK: - UseCase
    
    // MARK: - Home Flow Coordinator
    func makeHomeFlowCoordinator(fireStoreCollectionId: String) -> HomeFlowCoordinator {
        
        return HomeFlowCoordinator(dependencies: self)
    }
}

extension HomeSceneDIContainer: HomeFlowCoordinatorDependencies {}
