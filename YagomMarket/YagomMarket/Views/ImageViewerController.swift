//
//  ImageViewerController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/10.
//

import UIKit

final class ImageViewerController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    init(imageURLs: [String]) {
        super.init(nibName: nil, bundle: nil)
        setImages(imageURLs: imageURLs)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
    }
    
    private func setImages(imageURLs: [String]) {
        for url in imageURLs {
            let imageView = UIImageView.generate()
            imageView.clipsToBounds = false
            imageView.contentMode = .scaleAspectFit
            imageView.setImage(with: url)
            imageStackView.addArrangedSubview(imageView)
        }
    }
    
    private func setupInitialView() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(imageStackView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }
}
