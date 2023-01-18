//
//  DetailViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/29.
//

import Foundation

protocol ProductDetailViewModelInput {
    var completeDataFetching: (() -> Void)? { get set }
    
    func search(productID: Int)
}

protocol ProductDetailViewModelOutput {
    var productId: Int? { get }
    var images: [Image]? { get }
    var price: String? { get }
    var vendorName: String? { get }
    var time: String? { get }
    var description: String? { get }
    var name: String? { get }
}

protocol ProductDetailViewModel: ProductDetailViewModelInput, ProductDetailViewModelOutput {}

final class DefaultProductDetailViewModel: ProductDetailViewModel {
    private(set) var productId: Int?
    var images: [Image]?
    var price: String?
    var vendorName: String?
    var time: String?
    var description: String?
    var name: String?
    var completeDataFetching: (() -> Void)?
    
    func search(productID: Int) {
        productId = productID
        let searchProductDetailAPI = SearchProductDetailAPI(productId: productID)
        searchProductDetailAPI.execute { result in
            switch result {
            case .success(let data):
                self.parse(data: data)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func parse(data: SearchProductDetailAPI.ResponseType) {
        self.images = data.images
        if data.currency == .KRW {
            self.price = String(Int(data.price)).appending("원")
        } else {
            self.price = String(data.price).appending("달러")
        }
        self.vendorName = data.vendors.name
        self.time = DateCalculator.shared.calculatePostedDay(with: data.createdAt)
        self.description = data.description
        self.name = data.name
        completeDataFetching?()
    }
}
