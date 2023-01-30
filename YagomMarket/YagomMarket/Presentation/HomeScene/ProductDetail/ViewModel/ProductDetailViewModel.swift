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
    private let deleteProductUseCase: DeleteProductUseCase
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    private let productId: Int
    
    var productDetail: ProductDetail? {
        get async {
            await fetchProduct(with: productId)
        }
    }
    
    init(
        actions: ProductDetailViewModelActions,
        deleteProductUseCase: DeleteProductUseCase,
        fetchProductDetailUseCase: FetchProductDetailUseCase,
        productId: Int
    ) {
        self.actions = actions
        self.deleteProductUseCase = deleteProductUseCase
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
        self.productId = productId
    }
    
    private func fetchProduct(with id: Int) async -> ProductDetail? {
        do {
            let response = try await fetchProductDetailUseCase.execute(productId: productId)
            return response
        } catch let error as APIError {
            print(error.errorDescription ?? "Api Error 발생")
            return nil
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteProduct() async throws {
        try await deleteProductUseCase.execute(productId: productId)
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
