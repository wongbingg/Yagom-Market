//
//  HomeViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import UIKit

final class HomeViewController: UIViewController {
    // MARK: Properties
    private let viewModel = DefaultHomeViewModel()
    private let collectionView = ProductCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollectionView()
        
        setupTabBarController()
        setupCollectionView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Methods
    private func setupTabBarController() {
        tabBarController?.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = generateRefreshControl()
        collectionView.register(
            ProductCell.self,
            forCellWithReuseIdentifier: "Cell"
        )
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
    
    private func setupViewModel() {
        viewModel.productList.bind { _ in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        viewModel.resetToFirstPage()
    }
    
    @objc private func pullToRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.resetToFirstPage()
            self.collectionView.reloadData()
            sender.endRefreshing()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.productList.value[indexPath.row].id
        let detailVC = DetailViewController(productId: id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.productList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        ) as? ProductCell else {
            return UICollectionViewCell()
        }
        cell.setup(with: viewModel.productList.value[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
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
extension HomeViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if viewController is RegisterViewController {
            let registerVC = RegisterViewController()
            registerVC.delegate = self
            registerVC.modalPresentationStyle = .overFullScreen
            tabBarController.present(registerVC, animated: true)
            return false
        }
        
        if viewController is SearchViewController {
            let searchVC = SearchViewController()
            tabBarController.navigationController?.pushViewController(searchVC, animated: true)
            return false // 기존에 viewController를 보여주는 것을 하지 않는다는 뜻.
        }
        return true
    }
}

//MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let endY = (scrollView.contentSize.height)
        let currentY = scrollView.contentOffset.y + scrollView.bounds.height
        if currentY > endY + 50 {
            viewModel.addNextPage()
        }
    }
}

extension HomeViewController: RegisterViewControllerDelegate {
    func viewWillDisappear() {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.resetToFirstPage()
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Layout Constraints
private extension HomeViewController {
    
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
