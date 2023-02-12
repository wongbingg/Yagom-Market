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
        setupTableView()
        setupInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupTabBar()
        adoptTabBarDelegate()
        setupInitialData()
    }
    
    // MARK: Methods
    private func setupTableView() {
        chattingListView.delegate = self
        chattingListView.dataSource = self
        chattingListView.register(ChattingListCell.self, forCellReuseIdentifier: "ChattingListCell")
    }
    
    private func setupInitialData() {
        Task {
            do {
                try await viewModel.fetchChattingList()
                chattingListView.reloadData()
            } catch let error as LocalizedError {
                DefaultAlertBuilder(
                    title: .error,
                    message: error.errorDescription ?? "\(#function) error"
                )
                .setButton()
                .showAlert(on: self)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Chat"
    }
    
    private func setupTabBar() {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    private func adoptTabBarDelegate() {
        tabBarController?.delegate = self
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChattingListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.chattingCells.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChattingListCell",
            for: indexPath
        ) as? ChattingListCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.chattingCells[indexPath.row]
        cell.setupData(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        // TODO: 셀이 탭 되었을 때 액션정의
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRowAt(index: indexPath.row)
    }
}

// MARK: - UITabBarControllerDelegate
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
