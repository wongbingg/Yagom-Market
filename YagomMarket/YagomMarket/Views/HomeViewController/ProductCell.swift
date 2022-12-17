//
//  ProductCell.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    // MARK: UI Component
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 10
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
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
        stackView.axis = .vertical
        return stackView
    }()
    
    private let vendorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        return label
    }()
    
    private let fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
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
    func setup(with data: Page?) {
        guard let data = data else { return }
        productImageView.setImage(with: data.thumbnail)
        if data.currency == .KRW {
            priceLabel.text = String(data.price).appending("원")
        } else {
            priceLabel.text = String(data.price).appending("달러")
        }
        titleLabel.text = data.name
        vendorNameLabel.text = data.vendorName + "   •" + DateCalculator.shared.calculatePostedDay(with: data.createdAt)
    }
    
    func setupDefaultImage() {
        productImageView.image = UIImage(systemName: "clock")
    }
    
    private func setupInitialView() {
        backgroundColor = .systemBackground
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        priceLabel.text = nil
        titleLabel.text = nil
        vendorNameLabel.text = nil
    }
}

// MARK: - Layout Setup
private extension ProductCell {
    func addSubViews() {
        addSubview(productImageView)
        addSubview(labelStackView)
        addSubview(lowerStackView)
        
        labelStackView.addArrangedSubview(priceLabel)
        labelStackView.addArrangedSubview(titleLabel)
        
        lowerStackView.addArrangedSubview(vendorNameLabel)
        lowerStackView.addArrangedSubview(fakeView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: labelStackView.topAnchor, constant: -9),
        ])
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: lowerStackView.topAnchor, constant: -9),
        ])
        NSLayoutConstraint.activate([
            lowerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lowerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lowerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fakeView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
    }
}
