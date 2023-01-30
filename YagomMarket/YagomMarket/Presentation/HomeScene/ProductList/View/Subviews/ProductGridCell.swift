//
//  ProductGridCell.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class ProductGridCell: UICollectionViewCell {
    // MARK: Properties
    private var task: Task<Sendable, Error>?
    
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
        layoutProductImageView()
        layoutLabelStackView()
        layoutLowerStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setupUIComponents(with data: ProductCell?) {
        guard let data = data else { return }
        titleLabel.text = data.title
        setupPrice(with: data)
        setupVendorName(with: data)
        setupImage(with: data.imageURL)
    }
    
    func resultViewSetup() {
        priceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        vendorNameLabel.text = nil
    }
    
    private func setupInitialView() {
        backgroundColor = .systemBackground
    }
    
    private func setupVendorName(with data: ProductCell) {
        let separator = "   •"
        let postedDay = DateCalculator.shared.calculatePostedDay(with: data.postDate)
        vendorNameLabel.text = data.vendor + separator + postedDay
    }
    
    private func setupPrice(with data: ProductCell) {
        if data.currency == .KRW {
            let price = String(data.price)
            let kPrice = String(price.split(separator: ".")[0])
            priceLabel.text = kPrice.appending("원")
        } else {
            let price = String(data.price)
            priceLabel.text = price.appending("달러")
        }
    }
    
    private func setupImage(with imagePath: String) {
        task = Task {
            try Task.checkCancellation()
            do {
                try await productImageView.setImage(with: imagePath)
            } catch let error as APIError {
                print(error.errorDescription)
            }
            return Sendable.self
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage()
        task?.cancel()
    }
}

// MARK: - Layout Constraints
private extension ProductGridCell {
    
    func layoutProductImageView() {
        addSubview(productImageView)
        addSubview(labelStackView)
        addSubview(lowerStackView)
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: labelStackView.topAnchor, constant: -9),
        ])
    }
    
    func layoutLabelStackView() {
        labelStackView.addArrangedSubview(priceLabel)
        labelStackView.addArrangedSubview(titleLabel)
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: lowerStackView.topAnchor, constant: -9),
        ])
    }
    
    func layoutLowerStackView() {
        lowerStackView.addArrangedSubview(vendorNameLabel)
        lowerStackView.addArrangedSubview(fakeView)
        NSLayoutConstraint.activate([
            lowerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lowerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lowerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fakeView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
    }
}
