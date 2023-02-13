//
//  APIClient.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

struct APIClient {
    static let shared = APIClient(sesseion: URLSession.shared)
    private let session: URLSessionProtocol
    
    init(sesseion: URLSessionProtocol) {
        self.session = sesseion
    }

    func requestData(with urlRequest: URLRequest) async throws -> Data {
        var result: (data: Data, response: URLResponse)?
        
        do {
            result = try await session.data(for: urlRequest, delegate: nil)
        } catch {
            throw APIError.invalidURLRequest
        }
        
        let successRange = 200..<300
        
        guard let statusCode = (result?.response as? HTTPURLResponse)?.statusCode else {
            throw APIError.unknown
        }
        guard successRange.contains(statusCode) else {
            throw APIError.response(statusCode)
        }
        
        return result!.data
    }
}

// MARK: - URLSessionProtocol
protocol URLSessionProtocol {
    func data(for request: URLRequest,
              delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

