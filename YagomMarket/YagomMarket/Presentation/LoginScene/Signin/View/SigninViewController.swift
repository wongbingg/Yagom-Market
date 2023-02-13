//
//  SigninViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class SigninViewController: UIViewController {
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 100, left: 40, bottom: 200, right: 40)
        return stackView
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "이메일과 비밀번호를 입력하여 계정을 등록하세요."
        label.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.backgroundColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addLeftPadding()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "이메일을 입력하세요"
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addLeftPadding()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "비밀번호를 입력하세요"
        return textField
    }()
    
    private let vendorNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addLeftPadding()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "VendorName을 입력하세요"
        return textField
    }()
    
    private let identifierTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addLeftPadding()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "identifier을 입력하세요"
        return textField
    }()
    
    private let secretTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addLeftPadding()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "secret을 입력하세요"
        return textField
    }()
    
    private let viewModel: SigninViewModel
    
    init(with viewModel: SigninViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        addSubviews()
        setupConstraints()
        setupButton()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupButton() {
        registerButton.addTarget(
            self,
            action: #selector(registerButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func retrieveInfo() -> LoginInfo? {
        guard let id = idTextField.text,
              let password = passwordTextField.text,
              let vendorName = vendorNameTextField.text,
              let identifier = identifierTextField.text,
              let secret = secretTextField.text else { return nil }
        return LoginInfo(id: id,
                         password: password,
                         vendorName: vendorName,
                         identifier: identifier,
                         secret: secret)
    }
    
    private func successAlert(with id: String) {
        DefaultAlertBuilder(
            message: "\(id) 등록 완료 !"
        ).setButton(name: .confirm, style: .default) {
            _ = self.navigationController?.popViewController(animated: true)
        }.showAlert(on: self)
    }
    
    private func failAlert(with error: LocalizedError) {
        DefaultAlertBuilder(
            title: .warning,
            message: error.errorDescription ?? "\(#function) error"
        ).setButton(name: .yes, style: .default)
            .showAlert(on: self)
    }
    
    @objc private func registerButtonTapped() {
        guard let loginInfo = retrieveInfo() else {
            return
        }
        Task {
            do {
                try await viewModel.registerButtonTapped(loginInfo)
                successAlert(with: loginInfo.id)
            } catch let error as LocalizedError {
                failAlert(with: error)
            }
        }
    }
}

private extension SigninViewController {
    
    func addSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(subTitle)
        mainStackView.addArrangedSubview(textFieldStackView)
        textFieldStackView.addArrangedSubview(idTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        textFieldStackView.addArrangedSubview(vendorNameTextField)
        textFieldStackView.addArrangedSubview(identifierTextField)
        textFieldStackView.addArrangedSubview(secretTextField)
        mainStackView.addArrangedSubview(registerButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
