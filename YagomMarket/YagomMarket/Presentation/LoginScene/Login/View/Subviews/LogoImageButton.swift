//
//  LogoImageButton.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class LogoImageButton: UIButton {
    
    init(image: UIImage, radius: CGFloat) {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: radius*2, height: radius*2)))
        setSize(radius: radius)
        renderImage(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSize(radius r: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: r * 2),
            heightAnchor.constraint(equalToConstant: r * 2)
        ])
    }
    
    private func renderImage(image: UIImage) {
        self.imageView?.contentMode = .scaleAspectFill
        self.setImage(image, for: .normal)
    }
}
