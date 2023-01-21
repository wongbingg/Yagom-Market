//
//  RegisterView.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/02.
//

import UIKit

final class RegisterView: UIView {
    
    private enum PlaceHolder {
        static let whiteSpace = ""
        static let productName = "상품명"
        static let category = "카테고리"
        static let tag = "# 태그"
        static let price = "￦ 가격"
        static let description = """
- 구매 시기\n
- 브랜드 /모델명\n
- 제품의 상태 (사용감, 하자 유무 등)\n
* 서로가 믿고 거래할 수 있도록, 자세한 정보와 다양한 각도의 상품 사진을 올려주세요.
"""
    }
    var isFullImages: Bool = false
    
    // MARK: UIComponents
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 10, left: 20, bottom: 10, right: 20
        )
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let photoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let photoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return stackView
    }()
    
    let addPhotoButton: UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.image = UIImage(systemName: "camera.fill")
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 5
        button.tintColor = .systemBrown
        button.contentMode = .center
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return button
    }()
    
    private let currentPhotoCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/5"
        label.textColor = .systemGray3
        return label
    }()
    
    private let nameTextField = CustomTextField(placeholder: PlaceHolder.productName)
    private let categoryTextField = CustomTextField(placeholder: PlaceHolder.category)
    private let tagTextField = CustomTextField(placeholder: PlaceHolder.tag)
    private let priceTextField = CustomTextField(placeholder: PlaceHolder.price)
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .systemGray3
        textView.isScrollEnabled = false
        textView.text = PlaceHolder.description
        return textView
    }()
    
    private let accessoryView: UIView = {
        let uiview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 50))
        uiview.layer.borderWidth = 1
        uiview.layer.borderColor = UIColor.systemGray6.cgColor
        uiview.layer.backgroundColor = UIColor.systemBackground.cgColor
        return uiview
    }()
    
    let keyboardDownButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.tintColor = .systemBrown
        return button
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layoutMainScrollView()
        layoutMainStackView()
        layoutPhotoScrollView()
        layoutPhotoStackView()
        
        setupKeyboard()
        setupAccessoryView()
        descriptionTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func appendImage(_ image: Any?) {
        guard let image = image as? UIImage else { return }
        let customImageView = CustomImageView(image: image)
        customImageView.setupButtonAction(with: #selector(deleteButtonDidTapped), in: self)
        
        if photoStackView.subviews.count < 6 {
            photoStackView.addArrangedSubview(customImageView)
            updateCountLabel()
        } else {
            print("사진의 개수 초과 Alert 띄우기")
        }
    }
    
    func retrieveDomain() -> ProductPostRequestDTO {
        let model = ProductPostRequestDTO(
            name: nameTextField.text ?? "",
            description: descriptionTextView.text,
            price: Double(Int(priceTextField.text ?? "") ?? 0),
            currency: .KRW,
            discountedPrice: 0.0,
            stock: 10,
            secret: URLCommand.secretKey
        )
        return model
    }
    
    func retrieveImages() -> [UIImage] {
        var images = [UIImage]()
        var subviews = photoStackView.subviews
        subviews.removeFirst()
        subviews.forEach { uiview in
            let imageView = uiview.subviews.compactMap { $0 as? UIImageView }[0]
            images.append(imageView.image!)
        }
        return images
    }
    
    func getRemainedImagePlaces() -> Int {
        return 6 - photoStackView.subviews.count
    }
    
    func setupData(with model: ProductDetail?) {
        guard let model = model else { return }
        addPhotoButton.removeFromSuperview()
        nameTextField.text = model.name
        descriptionTextView.text = model.description
        descriptionTextView.textColor = .black
        let price = model.price.replacingOccurrences(of: "원", with: "")
        priceTextField.text = price
        model.imageURLs.forEach { imageURL in
            let imageView = UIImageView.generate2()
            imageView.setImage(with: imageURL)
            photoStackView.addArrangedSubview(imageView)
        }
    }
    
    private func updateCountLabel() {
        let imagesCount = photoStackView.subviews.count-1
        currentPhotoCountLabel.text = "\(imagesCount)/5"
        if imagesCount == 5 {
            isFullImages = true
        } else {
            isFullImages = false
        }
    }
    
    private func setupKeyboard() {
        priceTextField.keyboardType = .decimalPad
    }
    
    private func setProperColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor.white
                } else {
                    return UIColor.black
                }
            }
        } else {
            return UIColor.black
        }
    }

    
    @objc func deleteButtonDidTapped(_ sender: UIButton) {
        guard let customView = sender.superview else { return }
        customView.removeFromSuperview()
        updateCountLabel()
    }
}

// MARK: - UITextViewDelegate
extension RegisterView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if descriptionTextView.text == PlaceHolder.description {
            descriptionTextView.text = nil
            descriptionTextView.textColor = setProperColor()
        } else {
            
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if descriptionTextView.text == PlaceHolder.whiteSpace {
            descriptionTextView.text = PlaceHolder.description
            descriptionTextView.textColor = .systemGray3
        }
        return true
    }
}

// MARK: - Layout Constraints
private extension RegisterView {
    
    func layoutMainScrollView() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(photoScrollView)
        photoScrollView.addSubview(photoStackView)
        photoStackView.addArrangedSubview(addPhotoButton)
        addPhotoButton.addSubview(currentPhotoCountLabel)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func layoutMainStackView() {
        mainStackView.addArrangedSubview(nameTextField)
        mainStackView.addArrangedSubview(categoryTextField)
        mainStackView.addArrangedSubview(tagTextField)
        mainStackView.addArrangedSubview(priceTextField)
        mainStackView.addArrangedSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    func layoutPhotoScrollView() {
        NSLayoutConstraint.activate([
            photoStackView.topAnchor.constraint(equalTo: photoScrollView.contentLayoutGuide.topAnchor),
            photoStackView.bottomAnchor.constraint(equalTo: photoScrollView.contentLayoutGuide.bottomAnchor),
            photoStackView.leadingAnchor.constraint(equalTo: photoScrollView.contentLayoutGuide.leadingAnchor),
            photoStackView.trailingAnchor.constraint(equalTo: photoScrollView.contentLayoutGuide.trailingAnchor),
            photoStackView.heightAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.heightAnchor)
        ])
    }
    
    func layoutPhotoStackView() {
        NSLayoutConstraint.activate([
            currentPhotoCountLabel.centerXAnchor.constraint(equalTo: addPhotoButton.centerXAnchor),
            currentPhotoCountLabel.bottomAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: -5),
        ])
    }
    
    func setupAccessoryView() {
        accessoryView.addSubview(keyboardDownButton)
        NSLayoutConstraint.activate([
            keyboardDownButton.centerYAnchor.constraint(equalTo: accessoryView.centerYAnchor),
            keyboardDownButton.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor, constant: -10),
        ])
        descriptionTextView.inputAccessoryView = accessoryView
        priceTextField.inputAccessoryView = accessoryView
        nameTextField.inputAccessoryView = accessoryView
    }
}
