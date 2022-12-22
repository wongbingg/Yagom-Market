//
//  ProductCell.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    // MARK: Properties
    private var index: Int?
    private let imageCacheManager: ImageCacheManager = URLCacheManager()
    private let operationQueue = OperationQueue.current
    
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
    func setupUIComponents(with data: Page?, at index: Int) {
        self.index = index
        guard let data = data else { return }
        titleLabel.text = data.name
        setupPrice(with: data)
        setupVendorName(with: data)
        setupImage(with: URL(string: data.thumbnail), at: index)
    }
    
    func resultViewSetup() {
        priceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        vendorNameLabel.text = nil
    }
    
    private func setupInitialView() {
        backgroundColor = .systemBackground
    }
    
    private func setupVendorName(with data: Page) {
        let separator = "   •"
        let postedDay = DateCalculator.shared.calculatePostedDay(with: data.createdAt)
        vendorNameLabel.text = data.vendorName + separator + postedDay
    }
    
    private func setupPrice(with data: Page) {
        if data.currency == .KRW {
            let price = String(data.price)
            let kPrice = String(price.split(separator: ".")[0])
            priceLabel.text = kPrice.appending("원")
        } else {
            let price = String(data.price)
            priceLabel.text = price.appending("달러")
        }
    }
    
    private func setupImage(with url: URL?, at index: Int) {
        guard let url = url else { return }
        let workItem = BlockOperation {
            self.imageCacheManager.getImage(with: url) { image in
                guard self.index == index else { return }
                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            }
        }
        operationQueue?.addOperation(workItem)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage()
        operationQueue?.cancelAllOperations()
    }
}

// MARK: - Layout Constraints
private extension ProductCell {
    
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
