//
//  SearchViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation

struct SearchViewModelActions {
    let cellTapped: (String) -> Void
}

protocol SearchViewModelInput {}
protocol SearchViewModelOutput {}
protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {}

final class DefaultSearchViewModel: SearchViewModel {
    let actions: SearchViewModelActions
    
    init(actions: SearchViewModelActions) {
        self.actions = actions    
    }
}
