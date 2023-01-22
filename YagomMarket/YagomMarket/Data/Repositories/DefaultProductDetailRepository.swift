//
//  DefaultProductDetailRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/22.
//

import Foundation

final class DefaultProductDetailRepository: ProductDetailRepository {
    
    func fetchProductDetail(productId: Int) async throws -> ProductDetail {
        let api = SearchProductDetailAPI(productId: productId)
        
        do {
            let response = try await api.execute()
            return response.toDomain()
        } catch {
            throw error
        }
    }
    
    func editProductDetail(with editModel: ProductEditRequestDTO,
                           productId: Int) async throws {
        let api = EditProductAPI(editModel: editModel, productId: productId)
        
        do {
            _ = try await api.execute()
        } catch {
            throw error
        }
    }
    
    func deleteProduct(productId: Int) async throws {
        let searchDeleteURIAPI = SearchDeleteURIAPI(productId: productId)
        let deleteProductAPI = DeleteProductAPI()
        
        do {
            let deleteURI = try await searchDeleteURIAPI.execute()
            _ = try await deleteProductAPI.execute(with: deleteURI)
        } catch {
            throw error
        }
    }
}
