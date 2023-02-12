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
        return label
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
        messageLabel.text = model.body
        if model.sender == LoginCacheManager.fetchPreviousInfo()?.vendorName {
            // 오른쪽 정렬
            profileImageView.isHidden = true
            messageLabel.textAlignment = .right
        } else {
            // 왼쪽정렬에 프로필사진 적용
            profileImageView.isHidden = false
            messageLabel.textAlignment = .left
        }
    }
}

// MARK: - Layout Constraints
private extension MessageCell {
    
    func addSubviews() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(profileImageView)
        mainStackView.addArrangedSubview(messageLabel)
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
