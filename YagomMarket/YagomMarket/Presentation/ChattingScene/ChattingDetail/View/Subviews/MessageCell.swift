//
//  MessageCell.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/09.
//

import UIKit

final class MessageCell: UITableViewCell {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.layer.borderColor = UIColor.systemBrown.cgColor
        label.layer.borderWidth = 3
        label.layer.cornerRadius = 5
        return label
    }()
    
    private let leftFakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriority(230), for: .horizontal)
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        return view
    }()
    
    private let rightFakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriority(230), for: .horizontal)
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person")
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.transform = .init(scaleX: 1.5, y: 1.5)
        return imageView
    }()
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    private func setupInitialView() {
        backgroundColor = .systemBackground
    }
    
    func setupData(with model: Message) {
        messageLabel.text = "  \(model.body)  "
        if model.sender == LoginCacheManager.fetchPreviousInfo()?.vendorName {
            leftFakeView.isHidden = false
            profileImageView.isHidden = true
            rightFakeView.isHidden = true
        } else {
            leftFakeView.isHidden = true
            profileImageView.isHidden = false
            rightFakeView.isHidden = false
        }
    }
}

// MARK: - Layout Constraints
private extension MessageCell {
    
    func addSubviews() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(profileImageView)
        mainStackView.addArrangedSubview(leftFakeView)
        mainStackView.addArrangedSubview(messageLabel)
        mainStackView.addArrangedSubview(rightFakeView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
