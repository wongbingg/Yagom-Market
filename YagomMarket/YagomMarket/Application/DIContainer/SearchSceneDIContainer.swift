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
    
    // MARK: - UseCase
    
    // MARK: - Search Flow Coordinator
    func makeSearchFlowCoordinator() -> SearchFlowCoordinator {
        
        return SearchFlowCoordinator(dependencies: self)
    }
}

extension SearchSceneDIContainer: SearchFlowCoordinatorDependencies {}
