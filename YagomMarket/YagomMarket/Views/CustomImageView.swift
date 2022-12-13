//
//  CustomImageView.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/12.
//

import UIKit

final class CustomImageView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("x", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = UIColor.black.cgColor
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return button
    }()
    
    init(image: UIImage) {
        imageView.image = image
        super.init(frame: .zero)
        setupInitialView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        addSubview(imageView)
        addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            deleteButton.centerXAnchor.constraint(equalTo: imageView.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: imageView.topAnchor),
            deleteButton.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    func setupButtonAction(with selector: Selector, in view: UIView) {
        deleteButton.addTarget(
            view,
            action: selector,
            for: .touchUpInside
        )
    }
}
