//
//  MyPageViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/19.
//

import UIKit

final class MyPageViewController: UIViewController {
    // MARK: Properties
    let myPageView = MyPageView()
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutInitialView()
    }
}

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
