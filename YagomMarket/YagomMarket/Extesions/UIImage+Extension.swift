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
 
    func convertToData() -> Data { // 화질이 너무 구려짐
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
        
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
        return renderImage
    }
}
