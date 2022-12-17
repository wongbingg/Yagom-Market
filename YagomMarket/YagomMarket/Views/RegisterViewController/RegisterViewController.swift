//
//  RegisterViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit
import PhotosUI

protocol RegisterViewControllerDelegate: AnyObject {
    func viewWillDisappear()
}

final class RegisterViewController: UIViewController {
    // MARK: Properties
    private let registerView = RegisterView()
    private let viewModel = DefaultRegisterViewModel()
    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var productId: Int?
    weak var delegate: RegisterViewControllerDelegate?
    
    // MARK: UIComponents
    private let navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.isTranslucent = true
        navBar.barTintColor = UIColor.white
        return navBar
    }()
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.backgroundColor = .systemGray2
        return toolBar
    }()
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBrown
        button.layer.cornerRadius = 5
        return button
    }()
    
    init(with viewModel: DetailViewModel? = nil) {
        if viewModel != nil {
            registerView.setupData(with: viewModel)
            registerButton.setTitle("수정", for: .normal)
            productId = viewModel?.productId
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupNavigationBar()
        setupToolBar()
        setupButton()
        setupTapGesture()
        setupKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.viewWillDisappear()
    }
    
    // MARK: Methods
    private func setupInitialView() {
        view.backgroundColor = .white
        view.addSubview(registerView)
        registerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            registerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
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
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(dismissView)
        )
        navItem.leftBarButtonItem = cancelButton
        navigationBar.items = [navItem]
    }
    
    private func setupToolBar() {
        view.addSubview(toolBar)
        toolBar.addSubview(registerButton)
        NSLayoutConstraint.activate([
            toolBar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupButton() {
        if productId == nil {
            registerButton.addTarget(
                self,
                action: #selector(registerButtonDidTapped),
                for: .touchUpInside
            )
        } else {
            registerButton.addTarget(
                self,
                action: #selector(editButtonDidTapped),
                for: .touchUpInside
            )
        }
        registerView.keyboardDownButton.addTarget(
            self,
            action: #selector(closeButtonDidTapped),
            for: .touchUpInside
        )
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc private func closeButtonDidTapped() {
        view.endEditing(true)
    }
    
    @objc private func registerButtonDidTapped() {
        let domain = registerView.retrieveDomain()
        let images = registerView.retrieveImages()
        viewModel.adoptModel(with: domain)
        viewModel.adoptImages(with: images)
        viewModel.requestPost { description in
            DispatchQueue.main.async {
                DefaultAlertBuilder(title: nil, message: description, preferredStyle: .alert)
                    .setButton(name: "확인", style: .default) {
                        self.dismiss(animated: true)
                    }
                    .showAlert(on: self)
            }
        }
    }
    
    @objc private func editButtonDidTapped() {
        guard let productId = productId else { return }
        let domain = registerView.retrieveDomain()
        viewModel.adoptModel(with: domain)
        viewModel.requestPatch(with: productId) {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboarFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboarFrame.size.height,
            right: 0.0
        )
        registerView.mainScrollView.contentInset = contentInset
        registerView.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillDisappear(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        registerView.mainScrollView.contentInset = contentInset
        registerView.mainScrollView.scrollIndicatorInsets = contentInset
    }
}

// MARK: - PHPickerViewControllerDelegate
extension RegisterViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let existingSelection = self.selection
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = existingSelection[identifier] ?? result
        }
        selection = newSelection
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        
        if selection.isEmpty {
            print("선택이 되지 않음")
        } else {
            displaySelectedPhotos()
        }
    }
    
    private func displaySelectedPhotos() {
        selectedAssetIdentifiers.forEach { str in
            let itemProvider = selection[str]!.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard error == nil else {
                        print(String(describing: error))
                        return
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.registerView.appendImage(image)
                    }
                }
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension RegisterViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position = touch.location(in: registerView)
        if registerView.addPhotoButton.bounds.contains(position) {
            guard registerView.isFullImages == false else {
                DefaultAlertBuilder(
                    title: "오류",
                    message: "더 이상 사진이 들어갈 수 없습니다",
                    preferredStyle: .alert
                ).setButton(
                    name: "확인",
                    style: .default, nil
                ).showAlert(on: self)
                return false
            }
            presentPicker(filter: .images)
        }
        return true
    }
    
    private func presentPicker(filter: PHPickerFilter?) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = filter
        configuration.preferredAssetRepresentationMode = .current
        configuration.selection = .ordered
        configuration.selectionLimit = registerView.getRemainedImagePlaces()
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}
