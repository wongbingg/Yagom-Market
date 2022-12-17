//
//  DetailViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/29.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: Properties
    private let productId: Int
    private let detailView = DetailView()
    private let viewModel = DefaultDetailViewModel()
    
    init(productId: Int) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupTabBarController()
        viewModel.completeDataFetching = { [self] in
            DispatchQueue.main.async { [self] in
                detailView.setupData(with: viewModel)
                setupNavigationBar()
            }
        }
        viewModel.search(productID: productId)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        detailView.changeIndex()
    }

    // MARK: Methods
    private func setupTabBarController() {
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupNavigationBar() {
        guard viewModel.vendorName == "wongbing" else { return }
        let barbutton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                   style: .done,
                                   target: self, action: #selector(buttonDidTapped))
        navigationItem.rightBarButtonItem = barbutton
    }
    
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tapAction(_:))
        )
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func showEditView() {
        let editView = RegisterViewController(with: viewModel)
        editView.delegate = self
        editView.modalPresentationStyle = .overFullScreen
        present(editView, animated: true)
    }
    
    private func performDelete(_ completion: @escaping () -> Void) {
        let searchDeleteURIAPI = makeSearchDeleteURIAPI(with: productId)
        searchDeleteURIAPI.searchDeleteURI { result in
            switch result {
            case .success(let deleteURI):
                let deleteAPI = DeleteProductAPI()
                deleteAPI.execute(with: deleteURI) { result in
                    switch result {
                    case .success(_):
                        completion()
                    case .failure(let error):
                        print(String(describing: error))
                    }
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func makeSearchDeleteURIAPI(with id: Int) -> SearchDeleteURIAPI {
        let apiConfig = APIConfiguration(
            method: .post,
            base: URLCommand.host,
            path: URLCommand.products +
            URLCommand.productId(delete: id),
            body: DeleteKeyRequestModel(secret: URLCommand.secretKey),
            parameters: nil
        )
        return SearchDeleteURIAPI(configuration: apiConfig)
    }
    
    @objc private func tapAction(_ sender: UITouch) {
        let point = sender.location(in: view)
        if detailView.imageStackView.bounds.contains(point) {
            let currentPage = detailView.imageScrollView.contentOffset.x / UIScreen.main.bounds.maxX
            let urls = viewModel.images?.map { $0.url }
            let imageViewer = ImageViewerController(imageURLs: urls!, currentPage: Int(currentPage))
            imageViewer.modalPresentationStyle = .formSheet
            present(imageViewer, animated: true)
        }
    }
    
    @objc private func buttonDidTapped() {
        DefaultAlertBuilder(preferredStyle: .actionSheet)
            .setButton(name: "수정", style: .default) {
                self.showEditView()
            }
            .setButton(name: "삭제", style: .destructive) {
                DefaultAlertBuilder(title: "안내", message: "정말 삭제 하시겠습니까?", preferredStyle: .alert)
                    .setButton(name: "예", style: .default) { [self] in
                        performDelete {
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                    .setButton(name: "아니오", style: .destructive, nil)
                    .showAlert(on: self)
            }
            .setButton(name: "cancel", style: .cancel, nil)
            .showAlert(on: self)
    }
}

extension DetailViewController: RegisterViewControllerDelegate {
    func viewWillDisappear() {
        viewModel.search(productID: productId)
    }
}
