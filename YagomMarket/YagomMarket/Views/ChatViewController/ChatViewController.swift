//
//  ChatViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/19.
//


    // MARK: Properties
    
    // MARK: View LifeCycles

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
