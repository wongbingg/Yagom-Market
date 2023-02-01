//
//  SearchViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation

struct SearchViewModelActions {
    let goToResultVC: ([ProductCell]) -> Void
    let goToHomeTab: () -> Void
}

protocol SearchViewModelInput {
    func search(keyword: String) async throws
    func goToResultVC(with keyword: String) async throws
    func goToHomeTab()
}
protocol SearchViewModelOutput {
    var searchedResults: [String] { get set }
}
protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {}

final class DefaultSearchViewModel: SearchViewModel {
    private let actions: SearchViewModelActions
    private let searchQueryUseCase: SearchQueryUseCase
    private let searchQueryResultsUseCase: SearchQueryResultsUseCase
    var searchedResults: [String] = []
    
    init(
        actions: SearchViewModelActions,
        searchQueryUseCase: SearchQueryUseCase,
        searchQueryResultsUseCase: SearchQueryResultsUseCase
    ) {
        self.actions = actions
        self.searchQueryUseCase = searchQueryUseCase
        self.searchQueryResultsUseCase = searchQueryResultsUseCase
    }
    
    func search(keyword: String) async throws {
        let response = try await searchQueryUseCase.execute(keyword: keyword)
        searchedResults = response
    }
    
    @MainActor
    func goToResultVC(with keyword: String) async throws {
        let response = try await searchQueryResultsUseCase.execute(keyword: keyword)
        actions.goToResultVC(response.toDomain())
    }
    
    func goToHomeTab() {
        actions.goToHomeTab()
    }
}
