//
//  ProductCell.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

class ProductCell: UICollectionViewCell {
    // MARK: UI Component
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
//        stackView.spacing = 8
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true //
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 10
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private let lowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let vendorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray5
        return label
    }()
    
    private let fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        view.backgroundColor = .systemGray
        return view
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialView()
        addSubViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    private func setupInitialView() {
        backgroundColor = .systemBackground
        
    }
    
    private func addSubViews() {
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(lowerStackView)
        mainStackView.addArrangedSubview(fakeView)
        
        labelStackView.addArrangedSubview(priceLabel)
        labelStackView.addArrangedSubview(titleLabel)
        
        lowerStackView.addArrangedSubview(vendorNameLabel)
        lowerStackView.addArrangedSubview(timeLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            productImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.7),
            productImageView.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -9),
            titleLabel.bottomAnchor.constraint(equalTo: vendorNameLabel.topAnchor, constant: -9),
            fakeView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
    }
    
    func setup(with data: Page?) {
        guard let data = data else { return }
        productImageView.setImage(with: data.thumbnail)
        priceLabel.text = String(data.price) + "원"
        titleLabel.text = data.name
        vendorNameLabel.text = data.vendorName
        timeLabel.text = generateTimeLabel(with: data.issuedAt)
    }
    
    private func generateTimeLabel(with time: String) -> String {
        return ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        priceLabel.text = nil
        titleLabel.text = nil
        vendorNameLabel.text = nil
        timeLabel.text = nil
    }
}
