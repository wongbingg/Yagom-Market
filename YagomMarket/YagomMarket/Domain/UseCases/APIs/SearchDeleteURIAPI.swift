//
//  SearchDeleteURIAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/16.
//

struct SearchDeleteURIAPI: API {
    typealias ResponseType = String
    
    var configuration: APIConfiguration?
    
    init(productId: Int) {
        configuration = APIConfiguration(
            method: .post,
            base: URLCommand.host,
            path: URLCommand.products +
            URLCommand.productId(delete: productId),
            body: ProductDeleteKeyRequestDTO(secret: URLCommand.secretKey),
            parameters: nil
        )
    }
    
    func searchDeleteURI() async throws -> String {
        do {
            let response = try await execute()
            return response
        } catch {
            throw error
        }
    }
}
