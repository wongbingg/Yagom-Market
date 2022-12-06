//
//  HomeViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import UIKit

final class HomeViewController: UIViewController {
    // MARK: Properties
    let collectionView = ProductCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    let viewModel = DefaultHomeViewModel()
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        setupInitialView()
        adoptDataSource()
        registerCell()
        viewModel.productList.bind { _ in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        viewModel.requestProductList(pageNumber: 1, ItemPerPages: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Methods
    private func setupInitialView() {
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
    
    private func adoptDataSource() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerCell() {
        collectionView.register(ProductCell.self,
                                forCellWithReuseIdentifier: "Cell")
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.productList.value[indexPath.row].id
        let detailVC = DetailViewController(productId: id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

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

extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navCon = viewController as? UINavigationController {
            if navCon.viewControllers.first is RegisterViewController {
                let vc = RegisterViewController()
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true)
                return false
            }
        }
        return true
    }
}
