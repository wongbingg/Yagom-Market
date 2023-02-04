//
//  ImageCacheManager.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/09.
//

import UIKit

protocol ImageCacheManager {
    func getImage(with imageURL: URL) async throws -> Data
}

final class DefaultImageCacheManager: ImageCacheManager {
    private let cache = URLCache.shared
    
    func getImage(with imageURL: URL) async throws -> Data {
        let request = URLRequest(url: imageURL)
        
        if self.cache.cachedResponse(for: request) == nil {
            return try await downloadImage(with: imageURL)
        } else {
            return try loadImageFromCache(with: imageURL)
        }
    }
    
    func loadImageFromCache(with imageURL: URL) throws -> Data {
        let request = URLRequest(url: imageURL)
        
        if let data = self.cache.cachedResponse(for: request)?.data {
            return data
        } else {
            throw ImageCacheManagerError.failToLoadImageFromCache
        }
    }
    
    func downloadImage(with imageURL: URL) async throws -> Data {
        let request = URLRequest(url: imageURL)
        let (data, response) = try await URLSession.shared.data(for: request)
        let successRange = (200..<300)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw APIError.unknown }
        guard successRange.contains(statusCode) else { throw APIError.response(statusCode) }
        
        let cachedData = CachedURLResponse(response: response, data: data)
        self.cache.storeCachedResponse(cachedData, for: request)
        
        return data
    }
}

enum ImageCacheManagerError: LocalizedError {
    case failToLoadImageFromCache
    
    var errorDescription: String? {
        switch self {
        case .failToLoadImageFromCache:
            return "캐시에서 이미지를 불러오는데 실패했습니다."
        }
    }
}
