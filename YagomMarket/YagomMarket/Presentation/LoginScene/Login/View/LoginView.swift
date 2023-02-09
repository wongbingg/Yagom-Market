//
//  LoginView.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class LoginView: UIView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 40
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 100, left: 40, bottom: 0, right: 40)
        return stackView
    }()
    
    private let titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let HeaderTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.font = .boldSystemFont(ofSize: label.font.pointSize)
        label.text = "Yagom Market에 로그인 하세요."
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "내가 원하는 여러 상품을 사고 팔 수 있습니다."
        return label
    }()
    
    private let textFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.addLeftPadding()
        textField.placeholder = "이메일 입력"
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.addLeftPadding()
        textField.placeholder = "비밀번호 입력"
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.backgroundColor = UIColor.systemGray5.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("회원 가입", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    private let logoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        return stackView
    }()
    
    private let fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        view.setContentHuggingPriority(.init(100), for: .vertical)
        return view
    }()
    
    private let labelSeparator = LabelSeparator(text: " SNS 계정 로그인 ")
    
    let kakaoLogoImageButton = LogoImageButton(
        image: UIImage(named: "kakao_custom")!,
        radius: 30
    )
    
    let facebookLogoImageButton = LogoImageButton(
        image: UIImage(named: "facebook_custom")!,
        radius: 30
    )
    
    let appleLogoImageButton = LogoImageButton(
        image: UIImage(named: "apple_custom")!,
        radius: 30
    )
    
    init() {
        super.init(frame: .zero)
        setupInitialView()
        addSubviews()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialView() {
        backgroundColor = .systemBackground
    }
    
    func retrieveLoginInfo() -> LoginInfo? {
        guard let id = idTextField.text,
              let password = passwordTextField.text else { return nil }
        return LoginInfo(id: id, password: password, vendorName: nil)
    }
}

private extension LoginView {
    
    func addSubviews() {
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(titlesStackView)
        titlesStackView.addArrangedSubview(HeaderTitle)
        titlesStackView.addArrangedSubview(subTitle)
        
        mainStackView.addArrangedSubview(textFieldsStackView)
        textFieldsStackView.addArrangedSubview(idTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        
        mainStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(loginButton)
        buttonStackView.addArrangedSubview(signInButton)
        
        mainStackView.addArrangedSubview(labelSeparator)
        
        mainStackView.addArrangedSubview(logoStackView)
        logoStackView.addArrangedSubview(kakaoLogoImageButton)
        logoStackView.addArrangedSubview(facebookLogoImageButton)
        logoStackView.addArrangedSubview(appleLogoImageButton)
        mainStackView.addArrangedSubview(fakeView)
    }
    
    func setupLayer() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
