//
//  UIImage+Extension.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/17.
//

import UIKit

extension UIImage { // 수정 필요
    
    func convertToData() -> Data {
        var quality = 0.01
        while true {
            guard let image = self.jpegData(compressionQuality: quality) else { break }
            if image.count > 1024*300 {
                print("이미지 용량 300Kb 넘음")
                quality *= 0.0
            } else {
                return image
            }
        }
        return Data()
    }
}
