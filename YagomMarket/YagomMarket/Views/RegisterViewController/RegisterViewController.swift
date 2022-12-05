//
//  RegisterViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class RegisterViewController: UIViewController {
    // MARK: Properties
    private let registerView = RegisterView()
    private let navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.isTranslucent = true
        navBar.barTintColor = UIColor.white
        return navBar
    }()
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupNavigationBar()
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Methods
    private func setupInitialView() {
        view.backgroundColor = .white
        view.addSubview(registerView)
        registerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            registerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            registerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            registerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        let navItem = UINavigationItem(title: " ")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navItem.leftBarButtonItem = cancelButton
        navigationBar.items = [navItem]
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage { // 용량때문에 실제 post 안될수도..?
            registerView.appendImage(image)
        }
        dismiss(animated: true)
    }
}

extension RegisterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position = touch.location(in: registerView)
        if registerView.addPhotoButton.bounds.contains(position) {
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary // will deprecate
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        }
        return true
    }
}
