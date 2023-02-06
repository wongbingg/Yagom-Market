//
//  ProductDetailViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/29.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    // MARK: Properties
    private let detailView = ProductDetailView()
    private let viewModel: ProductDetailViewModel
    
    // MARK: Initializers
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutInitialView()
        setupInitialView()
        setupButton()
        setupNavigationBar()
        setupGestureRecognizer()
        setupTabBarController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        detailView.changeIndex()
    }
    
    // MARK: Methods
    private func setupInitialView() {
        Task {
            do {
                let model = try await viewModel.productDetail
                let isLiked = try await viewModel.isLiked
                detailView.setupLikeButton(isLike: isLiked)
                try await detailView.setupData(with: model)
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) - error")
            }
        }
    }
    
    private func setupButton() {
        detailView.likeButton.addTarget(
            self,
            action: #selector(likeButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(imageDidTapped(_:))
        )
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupTabBarController() {
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .systemBrown
        Task {
            do {
                guard try await viewModel.productDetail.vendorName == "wongbing" else { return }
                
                let rightBarButton = UIBarButtonItem(
                    image: UIImage(systemName: "ellipsis"),
                    style: .done,
                    target: self, action: #selector(rightBarButtonDidTapped)
                )
                navigationItem.rightBarButtonItem = rightBarButton
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) - error")
            }
        }
    }
    
    private func showEditView() {
        Task {
            do {
                try await viewModel.showEditView()
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) - error")
            }
        }
        //        let editView = RegisterViewController(with: viewModel)
        //        editView.delegate = self
        //        editView.modalPresentationStyle = .overFullScreen
        //        present(editView, animated: true)
    }
    
    private func performDelete() {
        Task {
            do {
                try await viewModel.deleteProduct()
                // completion 처리 성공 얼럿 띄우기
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) - error")
            }
        }
    }
    
    private func showDeleteAction() {
        DefaultAlertBuilder(title: .alert, message: "정말 삭제 하시겠습니까?", preferredStyle: .alert)
            .setButton(name: .yes, style: .default) { [self] in
                performDelete()
                self.navigationController?.popViewController(animated: true)
            }
            .setButton(name: .no, style: .destructive, nil)
            .showAlert(on: self)
    }
    
    @objc private func imageDidTapped(_ sender: UITouch) {
        let point = sender.location(in: view)
        if detailView.imageStackView.bounds.contains(point) {
            let currentPage = detailView.imageScrollView.contentOffset.x / UIScreen.main.bounds.maxX
            Task {
                do {
                    let urls = try await viewModel.productDetail.imageURLs
                    viewModel.showImageViewer(imageURLs: urls, currentPage: Int(currentPage))
                } catch let error as LocalizedError {
                    print(error.errorDescription ?? "\(#function) - error")
                }
            }
        }
    }
    
    @objc private func rightBarButtonDidTapped() {
        DefaultAlertBuilder(preferredStyle: .actionSheet)
            .setButton(name: .edit, style: .default) {
                self.showEditView()
            }
            .setButton(name: .delete, style: .destructive) {
                self.showDeleteAction()
            }
            .setButton(name: .cancel, style: .cancel, nil)
            .showAlert(on: self)
    }
    
    @objc private func likeButtonTapped() {
        detailView.likeButton.isSelected.toggle()
        if detailView.likeButton.isSelected == true {
            Task {
                do {
                    try await viewModel.addLikeProduct()
                } catch let error as LocalizedError {
                    print(error.errorDescription ?? "\(#function) - error")
                }
            }
        } else {
            Task {
                do {
                    try await viewModel.deleteLikeProduct()
                } catch let error as LocalizedError {
                    print(error.errorDescription ?? "\(#function) - error")
                }
            }
        }
    }
}

// MARK: - RegisterViewDelegate
extension ProductDetailViewController: RegisterViewControllerDelegate {
    func viewWillDisappear() {
        //        viewModel.search(productID: productId)
    }
}

// MARK: - Layout Constraints
private extension ProductDetailViewController {
    func layoutInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
