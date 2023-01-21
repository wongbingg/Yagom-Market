//
//  DetailViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/29.
//

import Foundation

struct ProductDetailViewModelActions {
    let imageTapped: ([String], Int) -> Void
    let showEditView: (ProductDetail) -> Void
}

protocol ProductDetailViewModelInput {
    func deleteProduct() async throws
    func showEditView() async
    func showImageViewer(imageURLs: [String], currentPage: Int)
}

protocol ProductDetailViewModelOutput {
    var productDetail: ProductDetail? { get async }
}

protocol ProductDetailViewModel: ProductDetailViewModelInput, ProductDetailViewModelOutput {}

final class DefaultProductDetailViewModel: ProductDetailViewModel {
    private let actions: ProductDetailViewModelActions
    private let productId: Int
    var productDetail: ProductDetail? {
        get async {
            await fetchProduct(with: productId)
        }
    }
    
    init(actions: ProductDetailViewModelActions, productId: Int) {
        self.actions = actions
        self.productId = productId
    }
    
    private func fetchProduct(with id: Int) async -> ProductDetail? {
        let api = SearchProductDetailAPI(productId: id)
        do {
            let response = try await api.execute()
            return response.toDomain()
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteProduct() async throws {
        let searchDeleteURIAPI = SearchDeleteURIAPI(productId: productId)
        let deleteURI = try await searchDeleteURIAPI.searchDeleteURI()
        let deleteAPI = DeleteProductAPI()
        _ = try await deleteAPI.execute(with: deleteURI)
    }
    
    @MainActor
    func showEditView() async {
        guard let productDetail = await productDetail else { return }
        actions.showEditView(productDetail)
    }
    
    func showImageViewer(imageURLs: [String], currentPage: Int) {
        actions.imageTapped(imageURLs, currentPage)
    }
}
