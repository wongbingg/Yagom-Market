//
//  ResultViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/20.
//

import UIKit

final class ResultViewController: UIViewController {
    private let viewModel: ResultViewModel
    
    private let collectionView = ProductCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: Initializers
    init(viewModel: ResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollectionView()
        Task {
            do {
                try await viewModel.fetchUserLikeList()
                setupCollectionView()
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) error")
            }
        }
    }
    
    // MARK: Methods
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductGridCell.self,
                                forCellWithReuseIdentifier: "Cell")
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        guard let cell = sender.superview as? ProductGridCell else { return }
        Task {
            do {
                try await viewModel.likeButtonTapped(
                    id: cell.productId,
                    isSelected: sender.isSelected
                )
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) error")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
       
        viewModel.didSelectItemAt(indexPath: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource
extension ResultViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.productCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell", for: indexPath) as? ProductGridCell else {
            return UICollectionViewCell()
        }
        let data = viewModel.productCells[indexPath.row]
        let isLike = viewModel.userLikeList.contains(data.id)
        
        cell.setupUIComponents(with: data, isLike: isLike)
        cell.resultViewSetup()
        cell.addTargetForLikeButton(#selector(likeButtonTapped), in: self)
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
