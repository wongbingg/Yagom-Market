//
//  DetailView.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class DetailView: UIView {
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
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setupConstraints()
        adopScrollViewDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setupData(with viewModel: DetailViewModel) {
        nameLabel.text = viewModel.name
        descriptionTextView.text = viewModel.description
        vendorNameLabel.text = viewModel.vendorName?.appending(" •")
        priceLabel.text = viewModel.price
        timeLabel.text = viewModel.time
        viewModel.images?.forEach({ image in
            let imageView = UIImageView.generate()
            imageView.setImage(with: image.url)
            imageStackView.addArrangedSubview(imageView)
        })
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
    
    private func adopScrollViewDelegate() {
        imageScrollView.delegate = self
    }
}

// MARK: - UIScrollViewDelegate
extension DetailView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeIndex()
    }
}

// MARK: - Layout Setup
private extension DetailView {
    
    func addSubViews() {
        addSubview(mainScrollView)
        addSubview(backgroundView)
        backgroundView.addSubview(pagingLabel)
        
        mainScrollView.addSubview(imageScrollView)
        mainScrollView.addSubview(mainStackView)
        
        imageScrollView.addSubview(imageStackView)
        
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(lowerStackView)
        mainStackView.addArrangedSubview(descriptionTextView)
        lowerStackView.addArrangedSubview(vendorNameLabel)
        lowerStackView.addArrangedSubview(timeLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pagingLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            pagingLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            
            backgroundView.heightAnchor.constraint(equalToConstant: 30),
            backgroundView.widthAnchor.constraint(equalToConstant: 50),
            backgroundView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: -20),
            backgroundView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: mainStackView.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5),
            imageScrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.heightAnchor)
        ])
    }
}
