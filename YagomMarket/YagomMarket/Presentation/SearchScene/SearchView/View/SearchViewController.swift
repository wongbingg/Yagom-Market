//
//  SearchViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: Properties
    private let searchBar = UISearchBar()
    
    private let searchDefaultView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    private let resultTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var viewModel: SearchViewModel
    
    init(with viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        layoutSearchView()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: Methods
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupNavigationBar() {
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .done,
            target: self,
            action: #selector(closeButtonDidTapped)
        )
        let homeButton = UIBarButtonItem(
            image: UIImage(systemName: "house"),
            style: .done,
            target: self,
            action: #selector(homeButtonDidTapped)
        )
        backButton.tintColor = .systemBrown
        homeButton.tintColor = .systemBrown
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = homeButton
    }
    
    private func setupTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
   
    @objc private func closeButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func homeButtonDidTapped() {
        // 홈뷰로 이동
        viewModel.goToHomeTab()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            resultTableView.removeFromSuperview()
            layoutSearchView()
        } else {
            searchDefaultView.removeFromSuperview()
            layoutResultView()
            Task {
                do {
                    try await viewModel.search(keyword: searchText)
                    resultTableView.reloadData()
                } catch let error as LocalizedError {
                    print(error.errorDescription ?? "\(#function) - error")
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchValue = searchBar.text else { return }
        Task {
            do {
                try await viewModel.goToResultVC(with: searchValue)
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) - error")
            }
        }
    }
}

// MARK: - Layout Constraints
private extension SearchViewController {
    
    func layoutSearchView() {
        view.addSubview(searchDefaultView)
        NSLayoutConstraint.activate([
            searchDefaultView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchDefaultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchDefaultView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchDefaultView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func layoutResultView() {
        view.addSubview(resultTableView)
        NSLayoutConstraint.activate([
            resultTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            resultTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            resultTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchedResults.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        cell.textLabel?.text = viewModel.searchedResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let searchValue = viewModel.searchedResults[indexPath.row]
        Task {
            do {
                try await viewModel.goToResultVC(with: searchValue)
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) - error")
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}
