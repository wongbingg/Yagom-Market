//
//  ProductListViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

struct ProductListViewModelActions {
    let productTapped: (Int) -> Void
    let registerTapSelected: () -> Void
    let searchTapSelected: () -> Void
}

protocol ProductListViewModelInput {
    func resetToFirstPage() async throws -> [ProductCell]
    func addNextPage() async throws -> [ProductCell]
    func didSelectItemAt(indexPath: Int)
    func registerTapSelected()
    func searchTapSelected()
}

protocol ProductListViewModelOutput {
    var productList: [ProductCell] { get }
}

protocol ProductListViewModel: ProductListViewModelInput, ProductListViewModelOutput {}

final class DefaultProductListViewModel: ProductListViewModel {
    private var hasNext: Bool?
    private var currentPage = 1
    private let currentItemPerPage = 50
    private let actions: ProductListViewModelActions
    private(set) var productList: [ProductCell] = []
    
    
    init(actions: ProductListViewModelActions) {
        self.actions = actions
    }
    
    @discardableResult
    func resetToFirstPage() async throws -> [ProductCell] {
        currentPage = 1
        let api = SearchProductListAPI(
            pageNumber: currentPage,
            itemPerPage: currentItemPerPage
        )
        let response = try await api.execute()
        hasNext = response.hasNext
        productList = response.toDomain()
        return response.toDomain()
    }
    
    @discardableResult
    func addNextPage() async throws -> [ProductCell] {
        guard let hasNext = hasNext, hasNext == true else { return [] } // 마지막 페이지에 대한 얼럿처리
        currentPage += 1
        let api = SearchProductListAPI(
            pageNumber: currentPage,
            itemPerPage: currentItemPerPage
        )
        let response = try await api.execute()
        self.hasNext = response.hasNext
        productList += response.toDomain()
        return response.toDomain()
    }
    
    func didSelectItemAt(indexPath: Int) {
        let id = productList[indexPath].id
        actions.productTapped(id)
    }
    
    func refresh() {
        // 특정 상품 수정 후 homeview로 나왔을 때 특정 상품의 수정사항이 반영되도록 
    }
    
    func searchTapSelected() {
        actions.searchTapSelected()
    }
    
    func registerTapSelected() {
        actions.registerTapSelected()
    }
}
