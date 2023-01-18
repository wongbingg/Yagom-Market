//
//  SearchViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: Properties
    private let searchView = SearchView()
    private let resultView = ResultView()
    private let searchBar = UISearchBar()
    private let viewModel: SearchViewModel
    
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
        layoutSearchView()
        setupNavigationBar()
    }
    
    // MARK: Methods
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
   
    @objc private func closeButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func homeButtonDidTapped() {
        // 홈뷰로 이동
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            resultView.removeFromSuperview()
            layoutSearchView()
        } else {
            searchView.removeFromSuperview()
            layoutResultView(with: searchText.lowercased())
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchValue = searchBar.text else { return }
        let api = SearchProductListAPI(
            pageNumber: 1,
            itemPerPage: 100,
            searchValue: searchValue.lowercased()
        )
        api.execute { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    let resultVC = ResultViewController(model: model)
                    self.navigationController?.pushViewController(
                        resultVC,
                        animated: true
                    )
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

// MARK: ResultViewDelegate
extension SearchViewController: ResultViewDelegate {
    
    func itemDidTapped(model: SearchProductListResponse) {
        let ResultVC = ResultViewController(model: model)
        self.navigationController?.pushViewController(
            ResultVC,
            animated: true
        )
    }
    
    func scrollViewDidScroll() {
        searchBar.endEditing(true)
    }
}

// MARK: - Layout Constraints
private extension SearchViewController {
    
    func layoutSearchView() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func layoutResultView(with title: String) {
        view.backgroundColor = .systemBackground
        view.addSubview(resultView)
        resultView.delegate = self
        resultView.searchValue(title)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            resultView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
