//
//  DefaultImageRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/26.
//

import Foundation

final class DefaultImageRepository {
    private let imageCacheManager: ImageCacheManager
    
    init(imageCacheManager: ImageCacheManager) {
        self.imageCacheManager = imageCacheManager
    }
}

extension DefaultImageRepository: ImageRepository {
  
    func fetchImage(with imagePath: String) async throws -> Data {
        guard let imageURL = URL(string: imagePath) else { throw APIError.invalidURL }
        return try await imageCacheManager.getImage(with: imageURL)
    }
}
