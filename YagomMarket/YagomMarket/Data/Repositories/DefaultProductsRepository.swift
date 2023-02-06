//
//  DefaultProductsRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/23.
//

import Foundation

final class DefaultProductsRepository {}

extension DefaultProductsRepository: ProductsRepository {
    
    func fetchProductsList(pageNumber: Int,
                           itemPerPage: Int,
                           searchValue: String? = nil) async throws -> ProductListResponseDTO {
        
        let api = SearchProductListAPI(
            pageNumber: pageNumber,
            itemPerPage: itemPerPage,
            searchValue: searchValue
        )
        let response = try await api.execute()
        
        return response
    }
    
    func fetchProductDetail(productId: Int) async throws -> ProductDetail {
        let api = SearchProductDetailAPI(productId: productId)
        let response = try await api.execute()
        
        return response.toDomain()
    }
    
    func fetchProductsQuery(keyword: String) async throws -> [String] {
        var list = [String]()
        let api = SearchProductListAPI(
            pageNumber: 1,
            itemPerPage: 100,
            searchValue: keyword.lowercased()
        )
        
        let response = try await api.execute()
        
        response.pages.forEach { page in
            list.append(page.name)
        }
        
        return Array(Set(list))
    }
    
    func requestPost(with registerModel: RegisterModel) async throws {
        let api = RegisterProductAPI(model: registerModel)
        _ = try await api.execute()
    }
    
    func editProductDetail(with editModel: ProductEditRequestDTO,
                           productId: Int) async throws {
        
        let api = EditProductAPI(editModel: editModel, productId: productId)
        _ = try await api.execute()
    }
    
    func deleteProduct(productId: Int) async throws {
        let searchDeleteURIAPI = SearchDeleteURIAPI(productId: productId)
        let deleteProductAPI = DeleteProductAPI()
        let deleteURI = try await searchDeleteURIAPI.execute()
        _ = try await deleteProductAPI.execute(with: deleteURI)
    }
}
