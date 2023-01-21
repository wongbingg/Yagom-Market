//
//  ChatViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/19.
//

import UIKit

final class ChatViewController: UIViewController {
    // MARK: Properties
    let chatView = ChatView()
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutInitialView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adoptTabBarDelegate()
    }
    
    private func adoptTabBarDelegate() {
        tabBarController?.delegate = self
    }
}

extension ChatViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if viewController is RegisterViewController {
//            viewModel.registerTapSelected()
            print("챗뷰에서 등록뷰 탭")
            return false
        }

        if viewController == tabBarController.children[1] {
//            viewModel.searchTapSelected()
            print("챗뷰에서 서치뷰 탭")
            return false
        }
        return true
    }
}

// MARK: - Layout Constraints
private extension ChatViewController {
    
    func layoutInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(chatView)
        chatView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chatView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chatView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
