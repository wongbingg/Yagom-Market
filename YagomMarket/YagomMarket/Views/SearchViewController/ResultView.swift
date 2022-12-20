//
//  ResultView.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/19.
//

import UIKit

protocol ResultViewDelegate: AnyObject {
    func scrollViewDidScroll()
    func itemDidTapped(model: SearchProductListResponse)
}

final class ResultView: UIView {
    // MARK: Properties
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var nameList = [String]()
    weak var delegate: ResultViewDelegate?
    
    // MARK: Initializers
    init() {
        super.init(frame: .zero)
        layoutInitialView()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func searchValue(_ title: String) {
        let api = SearchProductListAPI(
            pageNumber: 1,
            itemPerPage: 100,
            searchValue: title
        )
        api.execute { result in
            switch result {
            case .success(let success):
                var list = [String]()
                success.pages.forEach { page in
                    list.append(page.name)
                }
                self.nameList = Array(Set(list))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ResultView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        cell.textLabel?.text = nameList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let searchValue = nameList[indexPath.row]
        let api = SearchProductListAPI(
            pageNumber: 1,
            itemPerPage: 100,
            searchValue: searchValue
        )
        api.execute { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.delegate?.itemDidTapped(model: model)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll()
    }
}

// MARK: - Layout Constraints
private extension ResultView {
    
    func layoutInitialView() {
        backgroundColor = .systemBackground
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
