//
//  ProductListViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import UIKit

final class ProductListViewController: UIViewController {
    // MARK: Properties
    private let viewModel: ProductListViewModel
    private let collectionView = ProductCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    init(with viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollectionView()
        
        setupCollectionView()
        requestInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        adoptTabBarDelegate()
        setupNavigationBar()
//        requestInitialData()
    }
    
    // MARK: Methods
    private func adoptTabBarDelegate() {
        tabBarController?.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Home"
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = generateRefreshControl()
        collectionView.register(ProductGridCell.self,
                                forCellWithReuseIdentifier: "Cell")
    }
    
    private func generateRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBrown
        refreshControl.addTarget(
            self,
            action: #selector(pullToRefresh),
            for: .valueChanged
        )
        return refreshControl
    }
    
    private func requestInitialData() {
        Task {
            do {
                _ = try await viewModel.resetToFirstPage()
                collectionView.reloadData()
            } catch let error as LocalizedError {
                DefaultAlertBuilder(
                    title: .error,
                    message: error.errorDescription
                )
                .setButton(name: .confirm, style: .default)
                .showAlert(on: self)
            }
        }
    }
    
    @objc private func pullToRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Task {
                do {
                    _ = try await self.viewModel.resetToFirstPage()
                    self.collectionView.reloadData()
                    sender.endRefreshing()
                } catch let error as LocalizedError {
                    DefaultAlertBuilder(
                        title: .error,
                        message: error.errorDescription
                    )
                    .setButton(name: .confirm, style: .default)
                    .showAlert(on: self)
                    sender.endRefreshing()
                }
            }
        }
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        guard let cell = sender.superview as? ProductGridCell else { return }
        Task {
            do {
                try await viewModel.likeButtonTapped(id: cell.productId,
                                                     isSelected: sender.isSelected)
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) error")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell", for: indexPath) as? ProductGridCell else {
            return UICollectionViewCell()
        }
        let data = viewModel.productList[indexPath.row]
        let isLike = viewModel.userLikeList.contains(data.id)
        
        cell.setupUIComponents(with: viewModel.productList[indexPath.row], isLike: isLike)
        cell.addTargetForLikeButton(#selector(likeButtonTapped), in: self)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        flow.minimumLineSpacing = 5
        flow.minimumInteritemSpacing = 5
        flow.sectionInset = UIEdgeInsets(
            top: 10, left: 20,
            bottom: 10, right: 20
        )
        
        return CGSize(
            width: CGFloat(UIScreen.main.bounds.width / 2.0 - 25),
            height: CGFloat(UIScreen.main.bounds.height / 2.7)
        )
    }
}

// MARK: - UITabBarControllerDelegate
extension ProductListViewController: UITabBarControllerDelegate {
    
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

//MARK: - UIScrollViewDelegate
extension ProductListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let endY = (scrollView.contentSize.height)
        let currentY = scrollView.contentOffset.y + scrollView.bounds.height
        if currentY > endY + 40 {
            Task {
                do {
                    try await viewModel.addNextPage()
                    collectionView.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension ProductListViewController: RegisterViewControllerDelegate {
    func viewWillDisappear() {
        // TODO: RegisterView에서 상품등록 후 해당상품이 바로 업데이트 되도록
    }
}

// MARK: - Layout Constraints
private extension ProductListViewController {
    
    func layoutCollectionView() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
