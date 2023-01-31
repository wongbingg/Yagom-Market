//
//  MyPageViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/19.
//

import UIKit

final class MyPageViewController: UIViewController {
    // MARK: Properties
    private let myPageCellList = ["판매내역", "관심목록", "로그아웃"]
    private let viewModel: MyPageViewModel
    
    private let myPageTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        return tableView
    }()
    
    // MARK: Initializers
    init(with viewModel: MyPageViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        adoptTabBarDelegate()
        setupNavigationBar()
    }
    
    // MARK: Methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "MyPage"
    }
    
    private func adoptTabBarDelegate() {
        tabBarController?.delegate = self
    }
    
    private func setupTableView() {
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
    }
}

extension MyPageViewController: UITabBarControllerDelegate {
    
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

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return myPageCellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        cell.textLabel?.text = myPageCellList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            Task {
                do {
                    try await viewModel.myProductListCellTapped()
                } catch {
                    // TODO: Alert 처리
                }
            }
        case 1:
            viewModel.likedListCellTapped()
        case 2:
            DefaultAlertBuilder(title: "안내", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                .setButton(name: "확인", style: .default) { [weak self] in
                    self?.viewModel.logoutCellTapped()
                }
                .setButton(name: "취소", style: .destructive)
                .showAlert(on: self)
        default:
            return
        }
    }
}

// MARK: - Layout Constraints
private extension MyPageViewController {
    
    func layoutInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(myPageTableView)
        myPageTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myPageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myPageTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            myPageTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myPageTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
