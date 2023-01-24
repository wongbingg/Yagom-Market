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
    func resetToFirstPage() async throws
    func addNextPage() async throws
    func didSelectItemAt(indexPath: Int)
    func registerTapSelected()
    func searchTapSelected()
}

protocol ProductListViewModelOutput {
    var productList: [ProductCell] { get }
}

protocol ProductListViewModel: ProductListViewModelInput, ProductListViewModelOutput {}

final class DefaultProductListViewModel: ProductListViewModel {
    private let actions: ProductListViewModelActions
    private let addNextProductPageUseCase: AddNextProductPageUseCase
    private let resetToFirstProductPageUseCase: ResetToFirstProductPageUseCase
    private(set) var productList: [ProductCell] = []
    
    init(
        actions: ProductListViewModelActions,
        addNextProductPageUseCase: AddNextProductPageUseCase,
        resetToFirstProductPageUseCase: ResetToFirstProductPageUseCase
    ) {
        self.actions = actions
        self.addNextProductPageUseCase = addNextProductPageUseCase
        self.resetToFirstProductPageUseCase = resetToFirstProductPageUseCase
    }
    
    func resetToFirstPage() async throws {
        let response = try await resetToFirstProductPageUseCase.execute()
        productList = response
    }
    
    func addNextPage() async throws {
        let response = try await addNextProductPageUseCase.execute()
        productList += response
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
