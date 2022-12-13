//
//  ImageHandler.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/12.
//

import UIKit

class ImageCompressHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: UIImage) -> Data? {
        let data = request.jpegData(compressionQuality: 0.1)!
        if data.count > 300*1024 {
            return nextHandler?.handle(request: request)
        } else {
            return data
        }
    }
}

class ImageResizeHandler: Handler {
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
