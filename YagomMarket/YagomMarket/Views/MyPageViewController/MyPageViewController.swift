//
//  MyPageViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/19.
//


    // MARK: Properties
    
    // MARK: View LifeCycles

// MARK: - Layout Constraints
private extension MyPageViewController {
    
    func layoutInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(myPageView)
        myPageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myPageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myPageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            myPageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myPageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
