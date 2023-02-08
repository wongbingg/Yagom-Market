//
//  ChattingListViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/19.
//

import UIKit

final class ChattingListViewController: UIViewController {
    // MARK: Properties
    private let chattingListView = ChattingListView()
    private let viewModel: ChattingListViewModel
    
    // MARK: Initializers
    init(with viewModel: ChattingListViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        adoptTabBarDelegate()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Chat"
    }
    
    private func adoptTabBarDelegate() {
        tabBarController?.delegate = self
    }
}

extension ChattingListViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if viewController is RegisterViewController {
            viewModel.registerTapSelected()
            return false
        }

        if viewController == tabBarController.children[1] {
            viewModel.searchTapSelected()
            return false
        }
        return true
    }
}

// MARK: - Layout Constraints
private extension ChattingListViewController {
    
    func layoutInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(chattingListView)
        chattingListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chattingListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chattingListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chattingListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chattingListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
