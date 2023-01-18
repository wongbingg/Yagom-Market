//
//  ResultViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/20.
//

import UIKit

final class ResultViewController: UIViewController {
    private let model: SearchProductListResponse
    private let collectionView = ProductCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    init(model: SearchProductListResponse) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollectionView()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCell.self,
                                forCellWithReuseIdentifier: "Cell")
    }
}

// MARK: - UICollectionViewDelegate
extension ResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
       
        let id =  model.pages[indexPath.row].id
//        let detailVC = ProductDetailViewController(productId: id)
//        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ResultViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return model.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        ) as? ProductCell else {
            return UICollectionViewCell()
        }
        cell.setupUIComponents(with: model.pages[indexPath.row], at: indexPath.row)
        cell.resultViewSetup()
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ResultViewController: UICollectionViewDelegateFlowLayout {
    
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
            width: CGFloat(UIScreen.main.bounds.width / 3.0 - 25),
            height: CGFloat(UIScreen.main.bounds.height / 4.0)
        )
    }
}

// MARK: - Layout Constraints
private extension ResultViewController {
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
