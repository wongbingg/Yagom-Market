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
        setupLikeButton()
        setupGestureRecognizer()
        setupTabBarController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        detailView.changeIndex()
    }
    
    // MARK: Methods
    private func setupInitialView() {
        navigationController?.navigationBar.tintColor = .systemBrown
        Task {
            do {
                try await viewModel.fetchProduct()
                guard let productDetail = viewModel.productDetail else { return }
                try await detailView.setupData(with: productDetail)
                setupNavigationBar()
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) error")
            }
        }
    }
    
    private func setupLikeButton() {
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
        guard viewModel.productDetail?.vendorName == "wongbing" else { return } // vendorName 매직리터럴 해결
        
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .done,
            target: self, action: #selector(rightBarButtonDidTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func showEditView() {
        Task {
            do {
                try await viewModel.showEditView()
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) - error")
            }
        }
    }
    
    private func performDelete() {
        Task {
            do {
                try await viewModel.deleteProduct()
                // TODO: completion 처리 성공 얼럿 띄우기
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) - error")
            }
        }
    }
    
    private func showDeleteAction() {
        DefaultAlertBuilder(message: "정말 삭제 하시겠습니까?")
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
            guard let urls = viewModel.productDetail?.imageURLs else { return }
            viewModel.showImageViewer(imageURLs: urls, currentPage: Int(currentPage))
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
        // TODO: 해당 index의 셀 정보 업데이트
    }
}

extension ProductDetailViewController: ImageViewerViewControllerDelegate {
    func dismiss(_ viewController: UIViewController, at currentPage: Int) {
        detailView.scrollToPassedPage(currentPage)
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
