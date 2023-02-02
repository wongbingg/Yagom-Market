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
        do {
            let response = try await api.execute()
            return response
        } catch {
            throw ProductsRepositoryError.failToFetch
        }
    }
    
    func fetchProductDetail(productId: Int) async throws -> ProductDetail {
        let api = SearchProductDetailAPI(productId: productId)
        
        do {
            let response = try await api.execute()
            return response.toDomain()
        } catch {
            throw ProductsRepositoryError.noSuchProductId
        }
    }
    
    func fetchProductsQuery(keyword: String) async throws -> [String] {
        var list = [String]()
        let api = SearchProductListAPI(
            pageNumber: 1,
            itemPerPage: 100,
            searchValue: keyword.lowercased()
        )
        
        do {
            let response = try await api.execute()
            response.pages.forEach { page in
                list.append(page.name)
            }
            return Array(Set(list))
        } catch {
            throw ProductsRepositoryError.noSuchKeyword
        }
    }
    
    func editProductDetail(with editModel: ProductEditRequestDTO,
                           productId: Int) async throws {
        let api = EditProductAPI(editModel: editModel, productId: productId)
        
        do {
            _ = try await api.execute()
        } catch {
            throw ProductsRepositoryError.failToEdit
        }
    }
    
    func deleteProduct(productId: Int) async throws {
        let searchDeleteURIAPI = SearchDeleteURIAPI(productId: productId)
        let deleteProductAPI = DeleteProductAPI()
        
        do {
            let deleteURI = try await searchDeleteURIAPI.execute()
            _ = try await deleteProductAPI.execute(with: deleteURI)
        } catch {
            throw ProductsRepositoryError.failToDelete
        }
    }
}
