//
//  LoginViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    private var handle: AuthStateDidChangeListenerHandle?
    
    init(with viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupNavigationBar()
        setupButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        view = loginView
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func setupButton() {
        loginView.loginButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
        
        loginView.signInButton.addTarget(
            self,
            action: #selector(signInButtonTapped),
            for: .touchUpInside
        )
        
        loginView.kakaoLogoImageButton.addTarget(
            self,
            action: #selector(kakaoButtonTapped),
            for: .touchUpInside
        )

        loginView.facebookLogoImageButton.addTarget(
            self,
            action: #selector(facebookButtonTapped),
            for: .touchUpInside
        )

        loginView.appleLogoImageButton.addTarget(
            self,
            action: #selector(appleButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func loginButtonTapped() {
        guard let loginInfo = loginView.retrieveLoginInfo() else {
            return
        }
        Task {
            do {
                try await viewModel.loginButtonTapped(with: loginInfo)
            } catch let error as LocalizedError {
                DefaultAlertBuilder(
                    title: .warning,
                    message: error.errorDescription ?? "\(#function) error"
                )
                .setButton(name: .yes, style: .default)
                .showAlert(on: self)
            }
        }
    }
    
    @objc private func signInButtonTapped() {
        viewModel.createUserButtonTapped(with: nil)
    }
    
    @objc private func kakaoButtonTapped() {
        viewModel.kakaoLogoButtonTapped()
    }

    @objc private func facebookButtonTapped() {
        viewModel.facebookButtonTapped(in: self)
    }
    
    @objc private func appleButtonTapped() {
        DefaultAlertBuilder(title: .warning, message: "현재 사용할 수 없습니다")
            .setButton()
            .showAlert(on: self)
    }
}

