//
//  SearchViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation

struct SearchViewModelActions {
    let goToResultVC: (ProductListResponseDTO) -> Void
    let goToHomeTab: () -> Void
}

protocol SearchViewModelInput {
    func search(keyword: String) async throws -> [String]
    func goToResultVC(with keyword: String) async throws
    func goToHomeTab()
}
protocol SearchViewModelOutput {
    var searchedResults: [String] { get set }
}
protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {}

final class DefaultSearchViewModel: SearchViewModel {
    let actions: SearchViewModelActions
    var searchedResults: [String] = []
    
    init(actions: SearchViewModelActions) {
        self.actions = actions    
    }
    
    func search(keyword: String) async throws -> [String] {
        let api = SearchProductListAPI(
            pageNumber: 1,
            itemPerPage: 100,
            searchValue: keyword
        )
        let response = try await api.execute()
        var list = [String]()
        response.pages.forEach { page in
            list.append(page.name)
        }
        searchedResults = Array(Set(list))
        return searchedResults
    }
    
    @MainActor
    func goToResultVC(with keyword: String) async throws {
        let api = SearchProductListAPI(
            pageNumber: 1,
            itemPerPage: 100,
            searchValue: keyword.lowercased()
        )
        
        let response = try await api.execute()
        actions.goToResultVC(response)
    }
    
    func goToHomeTab() {
        actions.goToHomeTab()
    }
}
