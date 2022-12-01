//
//  UIImageView+Extension.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

extension UIImageView {
    func setImage(with thumbnail: String) {
        guard let url = URL(string: thumbnail) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
