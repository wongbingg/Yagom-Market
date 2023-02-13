//
//  ChattingDetailViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/09.
//

import UIKit

final class ChattingDetailViewController: UIViewController {
    private let viewModel: ChattingDetailViewModel
    private var toolBarBottomConstraints: NSLayoutConstraint?
    
    private let chattingDetailView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactiveWithAccessory
        return tableView
    }()
    
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.backgroundColor = .systemGray2
        return toolBar
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("보내기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBrown
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addLeftPadding()
        textField.backgroundColor = .systemGray6
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    // MARK: Initializers
    init(viewModel: ChattingDetailViewModel) {
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
        setupInitialData()
        addSubviews()
        layoutChattingDetailView()
        layoutToolBar()
        setupTableView()
        setupButton()
        adoptTextFieldDelegate()
        setupKeyboardNotification()
        viewModel.subscribe {
            self.setupInitialData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.removeListener()
    }
    
    // MARK: Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupInitialData() {
        Task {
            do {
                try await viewModel.fetchMessages()
                chattingDetailView.reloadData()
                scrollToBottom()
            } catch let error as LocalizedError {
                showErrorAlert(with: error.errorDescription ?? "\(#function) error")
            }
        }
    }
    
    private func setupTableView() {
        chattingDetailView.delegate = self
        chattingDetailView.dataSource = self
        chattingDetailView.register(
            MessageCell.self,
            forCellReuseIdentifier: "MessageCell"
        )
    }
    
    private func setupButton() {
        sendButton.addTarget(
            self,
            action: #selector(sendButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func adoptTextFieldDelegate() {
        messageTextField.delegate = self
    }
    
    private func showErrorAlert(with errorMessage: String) {
        DefaultAlertBuilder(
            title: .error,
            message: errorMessage
        )
        .setButton()
        .showAlert(on: self)
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @MainActor
    private func sendMessage(with body: String) async throws {
        messageTextField.text = ""
        try await viewModel.sendMessage(body: body)
        chattingDetailView.reloadData()
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        guard viewModel.messages.count > 0 else { return }
        let indexPath = IndexPath(row: viewModel.messages.count-1, section: 0)
        chattingDetailView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func sendButtonTapped() {
        guard let body = messageTextField.text else { return }
        Task {
            do {
                try await sendMessage(with: body)
            } catch let error as LocalizedError {
                showErrorAlert(with: error.errorDescription ?? "\(#function) error")
            }
        }
    }
    
    @objc private func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboarFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboarFrame.size.height,
            right: 0.0
        )
        chattingDetailView.contentInset = contentInset
        chattingDetailView.scrollIndicatorInsets = contentInset
        
        UIView.animate(withDuration: 1.0) {
            self.toolBarBottomConstraints?.constant = -keyboarFrame.size.height + 15
            self.toolBarBottomConstraints?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillDisappear(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        
        UIView.animate(withDuration: 1.0) {
            self.chattingDetailView.contentInset = contentInset
            self.chattingDetailView.scrollIndicatorInsets = contentInset
            self.toolBarBottomConstraints?.constant = 0
            self.toolBarBottomConstraints?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: UITableViewDelegate, DataSource {
extension ChattingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
                as? MessageCell else {
            return UITableViewCell()
        }
        let model = viewModel.messages[indexPath.row]
        cell.setupData(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ChattingDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
}

// MARK: Layout Constraints
private extension ChattingDetailViewController {
    
    func addSubviews() {
        view.addSubview(chattingDetailView)
        view.addSubview(toolBar)
        toolBar.addSubview(messageTextField)
        toolBar.addSubview(sendButton)
    }
    
    func layoutChattingDetailView() {
        NSLayoutConstraint.activate([
            chattingDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chattingDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            chattingDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chattingDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func layoutToolBar() {
        toolBarBottomConstraints = toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            toolBar.heightAnchor.constraint(equalToConstant: 70),
            toolBarBottomConstraints!,
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            messageTextField.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: 20),
            messageTextField.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor, constant: 20),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -20),
            messageTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
