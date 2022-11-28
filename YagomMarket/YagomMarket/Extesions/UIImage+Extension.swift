//
//  UIImage+Extension.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/17.
//

import UIKit

extension UIImage {
    func convertToData() -> Data {
        guard let image = self.jpegData(compressionQuality: 0.5) else { return Data() } // 에러를 던져주어도 괜찮을듯..?
        return image
    }
}
