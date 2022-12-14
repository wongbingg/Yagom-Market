//
//  ImageViewerController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/10.
//

import UIKit

final class ImageViewerController: UIViewController {
    // MARK: Properties
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
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var images: [UIImage] = []
    
    // MARK: Initializers
    init(imageURLs: [String], currentPage: Int) {
        super.init(nibName: nil, bundle: nil)
        setImages(imageURLs: imageURLs)
        setupPageControl(total: imageURLs.count,
                         index: currentPage)
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutInitialView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentOffset.x = (UIScreen.main.bounds.maxX) * CGFloat(pageControl.currentPage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 페이지 인덱스 정보를 DetailViewController 에 전달해주기
    }
    
    // MARK: Methods
    private func setImages(imageURLs: [String]) {
        for url in imageURLs {
            let imageView = UIImageView.generate()
            imageView.clipsToBounds = false
            imageView.contentMode = .scaleAspectFit
            imageView.setImage(with: url)
            imageStackView.addArrangedSubview(imageView)
        }
    }
    
    private func setupPageControl(total: Int, index: Int) {
        pageControl.numberOfPages = total
        pageControl.currentPage = index
        pageControl.pageIndicatorTintColor = UIColor.systemGray
        pageControl.addTarget(
            self,
            action: #selector(pageValueDidChanged),
            for: .valueChanged
        )
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
    }
    
    @objc func pageValueDidChanged(_ sender: UIPageControl) {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.scrollView.contentOffset.x = (UIScreen.main.bounds.maxX) * CGFloat(sender.currentPage)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImageViewerController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = UIScreen.main.bounds.width
        let halfWidth = UIScreen.main.bounds.width/2
        if scrollView.contentOffset.x < halfWidth {
            pageControl.currentPage = 0
        } else if scrollView.contentOffset.x > halfWidth
                    && scrollView.contentOffset.x < width+halfWidth {
            pageControl.currentPage = 1
        } else if scrollView.contentOffset.x > width+halfWidth
                    && scrollView.contentOffset.x < (width*2)+halfWidth {
            pageControl.currentPage = 2
        } else if scrollView.contentOffset.x > (width*2)+halfWidth
                    && scrollView.contentOffset.x < (width*3)+halfWidth {
            pageControl.currentPage = 3
        } else if scrollView.contentOffset.x > (width*3)+halfWidth
                    && scrollView.contentOffset.x < (width*4)+halfWidth {
            pageControl.currentPage = 4
        }
    }
}

// MARK: - Layout Constraints
private extension ImageViewerController {
    
     func layoutInitialView() {
        view.backgroundColor = .black
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        view.addSubview(scrollView)
        scrollView.addSubview(imageStackView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
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
