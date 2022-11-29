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
        viewModel.didFetchedData = { [self] in
            DispatchQueue.main.async { [self] in
                detailView.setupData(with: viewModel)
            }
        }
        viewModel.search(productID: productId)
    }
    
    // MARK: Methods
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
    }
}
