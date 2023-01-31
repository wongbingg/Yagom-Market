//
//  API.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

protocol API {
    associatedtype ResponseType: Decodable
    var configuration: APIConfiguration? { get }
}

extension API {
    
    func execute(using client: APIClient = APIClient.shared) async throws -> ResponseType {
        guard let urlRequest = configuration?.makeURLRequest() else { throw APIError.invalidURL }
        
        let data = try await client.requestData(with: urlRequest)
        if ResponseType.self == String.self {
            let result = String(data: data, encoding: .utf8)!
            return result as! Self.ResponseType
        }
        do {
            let result = try JSONDecoder().decode(ResponseType.self, from: data)
            return result
        } catch {
            throw APIError.failToParse
        }
    }
}
