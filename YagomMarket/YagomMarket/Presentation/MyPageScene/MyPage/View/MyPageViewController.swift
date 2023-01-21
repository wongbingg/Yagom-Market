//
//  MyPageViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/19.
//

import UIKit

final class MyPageViewController: UIViewController {
    // MARK: Properties
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        adoptTabBarDelegate()
    }
    
    private func adoptTabBarDelegate() {
        tabBarController?.delegate = self
    }
}

extension MyPageViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if viewController is RegisterViewController {
            viewModel.registerTapSelected()
            print("마이페이지에서 등록뷰 탭")
            return false
        }

        if viewController == tabBarController.children[1] {
            viewModel.searchTapSelected()
            print("마이페이지에서 서치뷰 탭")
            return false
        }
        return true
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
