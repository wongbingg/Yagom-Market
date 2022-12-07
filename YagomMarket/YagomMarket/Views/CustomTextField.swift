//
//  CustomTextField.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/05.
//

import UIKit

final class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.boldSystemFont(ofSize: 20)
        self.placeholder = placeholder
        self.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let separator = UIBezierPath()
        separator.move(to: CGPoint(x: 0, y: bounds.maxY))
        separator.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        separator.lineWidth = 2
        UIColor.lightGray.setStroke()
        separator.stroke()
        separator.close()
    }
}
