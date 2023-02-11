//
//  MessageCell.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/09.
//

import UIKit

final class MessageCell: UITableViewCell {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person")
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
        backgroundColor = .systemGray3
    }
    
    func setupData(with model: Message) {
        messageLabel.text = model.body
        if model.sender == LoginCacheManager.fetchPreviousInfo()?.vendorName {
            // 오른쪽 정렬
        } else {
            // 왼쪽정렬에 프로필사진 적용
        }
    }
}

// MARK: - Layout Constraints
private extension MessageCell {
    
    func addSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            profileImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
