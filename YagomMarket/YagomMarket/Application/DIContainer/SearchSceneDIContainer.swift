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
        return DefaultSearchViewModel(actions: actions)
    }
    
    // MARK: - Result
    func makeResultViewController(model: ProductListResponseDTO, actions: ResultViewModelAction) -> ResultViewController {
        let viewModel = makeResultViewModel(model: model, actions: actions)
        return ResultViewController(viewModel: viewModel)
    }
    
    func makeResultViewModel(model: ProductListResponseDTO,actions: ResultViewModelAction) -> ResultViewModel {
        return DefaultResultViewModel(model: model, actions: actions)
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
    
    // MARK: - Search Flow Coordinator
    func makeSearchFlowCoordinator() -> SearchFlowCoordinator {
        
        return SearchFlowCoordinator(dependencies: self)
    }
}

extension SearchSceneDIContainer: SearchFlowCoordinatorDependencies {}
