//
//  ProductDetailView.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class ProductDetailView: UIView {
    // MARK: UIComponents
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 20, left: 20, bottom: 0, right: 20
        )
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .normal
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let pagingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private let backgroundView: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .black
        uiview.layer.cornerRadius = 3
        uiview.layer.opacity = 0.4
        uiview.layer.masksToBounds = true
        return uiview
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    private let lowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let vendorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.textColor = .systemGray
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .red
        button.transform = CGAffineTransform(scaleX: 2, y: 2)
        button.isHidden = true
        return button
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutMainScrollView()
        layoutImageScrollView()
        layoutImageStackView()
        layoutMainStackView()
        layoutBackgroundView()
        layoutPagingLabel()

        adopScrollViewDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setupData(with model: ProductDetail) async throws {
        nameLabel.text = model.name
        descriptionTextView.text = model.description
        vendorNameLabel.text = model.vendorName.appending(" •")
        setupPrice(with: model)
        timeLabel.text = model.time.split(separator: "T").compactMap { String($0) }[0]
        likeButton.isHidden = false
        likeButton.isSelected = model.isLiked
        guard imageStackView.arrangedSubviews.isEmpty else { return }
        for imageURL in model.imageURLs {
            let imageView = UIImageView.generate()
            try await imageView.setImage(with: imageURL)
            imageStackView.addArrangedSubview(imageView)
        }
    }
    
    private func setupPrice(with data: ProductDetail) {
        if data.currency == .KRW {
            let price = String(data.price)
            let kPrice = String(price.split(separator: ".")[0])
            priceLabel.text = kPrice.appending("원")
        } else {
            let price = String(data.price)
            priceLabel.text = price.appending("달러")
        }
    }
    
    func changeIndex() {
        let imageCount = imageStackView.subviews.count
        guard imageCount > 1 else {
            backgroundView.isHidden = true
            return
        }
        backgroundView.isHidden = false
        let width = UIScreen.main.bounds.width
        let halfWidth = UIScreen.main.bounds.width/2
        if imageScrollView.contentOffset.x < halfWidth {
            pagingLabel.text = "1 / \(imageCount)"
        } else if imageScrollView.contentOffset.x > halfWidth
                    && imageScrollView.contentOffset.x < width+halfWidth {
            pagingLabel.text = "2 / \(imageCount)"
        } else if imageScrollView.contentOffset.x > width+halfWidth
                    && imageScrollView.contentOffset.x < (width*2)+halfWidth {
            pagingLabel.text = "3 / \(imageCount)"
        } else if imageScrollView.contentOffset.x > (width*2)+halfWidth
                    && imageScrollView.contentOffset.x < (width*3)+halfWidth {
            pagingLabel.text = "4 / \(imageCount)"
        } else if imageScrollView.contentOffset.x > (width*3)+halfWidth
                    && imageScrollView.contentOffset.x < (width*4)+halfWidth {
            pagingLabel.text = "5 / \(imageCount)"
        }
    }
    
    func scrollToPassedPage(_ number: Int) {
        let width = UIScreen.main.bounds.width
        imageScrollView.setContentOffset(
            CGPoint(x: Int(width)*number, y: 0),
            animated: false
        )
    }
    
    private func adopScrollViewDelegate() {
        imageScrollView.delegate = self
    }
}

// MARK: - UIScrollViewDelegate
extension ProductDetailView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeIndex()
    }
}

// MARK: - Layout Constraints
private extension ProductDetailView {
    
    func layoutMainScrollView() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(imageScrollView)
        mainScrollView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func layoutImageScrollView() {
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: mainStackView.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5),
            imageScrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
    func layoutImageStackView() {
        imageScrollView.addSubview(imageStackView)
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.heightAnchor)
        ])
    }
    
    func layoutMainStackView() {
        mainStackView.addArrangedSubview(likeButton)
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(lowerStackView)
        lowerStackView.addArrangedSubview(vendorNameLabel)
        lowerStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
        ])
    }
    
    func layoutBackgroundView() {
        addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 30),
            backgroundView.widthAnchor.constraint(equalToConstant: 50),
            backgroundView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: -20),
            backgroundView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20)
        ])
    }
    
    func layoutPagingLabel() {
        backgroundView.addSubview(pagingLabel)
        NSLayoutConstraint.activate([
            pagingLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            pagingLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
    }
}
