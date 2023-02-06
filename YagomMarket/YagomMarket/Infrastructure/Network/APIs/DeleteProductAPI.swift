//
//  DeleteProductAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/16.
//

import Foundation

class DeleteProductAPI: API {
    typealias ResponseType = ProductDetailResponseDTO
    
    var configuration: APIConfiguration? = APIConfiguration()
    
    func execute(with deleteURI: String) async throws -> ResponseType {
        let apiConfig = APIConfiguration(
            method: .delete,
            base: URLCommand.host,
            path: deleteURI,
            parameters: nil
        )
        configuration = apiConfig
        do {
            let response = try await execute()
            return response
        } catch {
            throw error
        }
    }
}
