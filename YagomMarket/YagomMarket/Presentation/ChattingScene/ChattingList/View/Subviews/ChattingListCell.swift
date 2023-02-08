//
//  ChattingListCell.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/08.
//

import UIKit

final class ChattingListCell: UITableViewCell {
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .label
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.numberOfLines = 2
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
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setupData(with model: ChattingCell) {
        titleLabel.text = model.buddyId
        subTitleLabel.text = model.lastMessage
        
    }
}

// MARK: - Layout Constraints
private extension ChattingListCell {
    
    func addSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subTitleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            profileImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
