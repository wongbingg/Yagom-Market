//
//  UIImageView+Extension.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

extension UIImageView {
    
    var imageRepository: ImageRepository {
        return DefaultImageRepository(imageCacheManager: DefaultImageCacheManager())
    }
    
    static func generate() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return imageView
    }
    
    static func generateToRegister() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return imageView
    }
    
    @MainActor
    func setImage(with imageURL: String) async throws {
        let data = try await imageRepository.fetchImage(with: imageURL)
        guard let image = UIImage(data: data) else { return }
        self.image = image
    }
}
