//
//  UIImage+Extension.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/17.
//

import UIKit

extension UIImage {
    var byteCount: Int {
        return self.jpegData(compressionQuality: 1.0)!.count
    }
 
    func convertToData() -> Data {
        var width = CGFloat(300)
        var image = self
        while image.byteCount > 1024*300 {
            image = image.resize(newWidth: width)
            width -= 5
        }
        return image.jpegData(compressionQuality: 1.0)!
    }
    
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size).integral)
        }
        return renderImage
    }

    func downSample(scale: CGFloat) -> UIImage {
        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
        let data = self.pngData()! as CFData
        let imageSource = CGImageSourceCreateWithData(data, nil)!
        let maxPixel = max(self.size.width, self.size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary

        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!

        let newImage = UIImage(cgImage: downSampledImage)
        return newImage
    }
}
