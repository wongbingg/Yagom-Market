//
//  RegisterViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class RegisterViewController: UIViewController {
    // MARK: Properties
    let registerView = RegisterView()
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
    }
    
    // MARK: Methods
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(registerView)
        registerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            registerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            registerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            registerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
