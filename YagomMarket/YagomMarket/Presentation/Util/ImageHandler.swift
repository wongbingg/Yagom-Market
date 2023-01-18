//
//  ImageHandler.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/12.
//

import UIKit

final class ImageCompressHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: UIImage) -> Data? {
        let data = request.jpegData(compressionQuality: 0.1)!
        if data.count <= 300*1024 {
            return data
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

final class ImageResizeHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: UIImage) -> Data? {
        let data = request.convertToData()
        if data.count > 300*1024 {
            return nil
        } else {
            return data
        }
    }
}

final class ImageDownsizeHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: UIImage) -> Data? {
        var quality = 0.1
        while quality > 0 {
            let image = request.downSample(scale: quality)
            if image.byteCount <= 300*1024 {
                return image.jpegData(compressionQuality: 1.0)
            } else {
                quality -= 0.02
            }
        }
        return nil
    }
}
