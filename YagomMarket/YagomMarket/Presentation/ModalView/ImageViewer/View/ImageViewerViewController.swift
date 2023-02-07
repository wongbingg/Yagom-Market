//
//  ImageViewerViewController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/10.
//

import UIKit

protocol ImageViewerViewControllerDelegate: AnyObject {
    func dismiss(_ viewController: UIViewController, at currentPage: Int)
}

final class ImageViewerViewController: UIViewController {
    // MARK: Properties
    private var originSize = CGSize(width: 0, height: 0)
    private var originalPosition = CGPoint(x: 0, y: 0)
    private let customTransitioningDelegate = ImageViewerTransitioningDelegate()
    weak var delegate: ImageViewerViewControllerDelegate?
    
    // MARK: UI Components
    private let mainScrollView: UIScrollView = {
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
    
    // MARK: Initializers
    init(
        imageURLs: [String],
        currentPage: Int,
        delegate: ImageViewerViewControllerDelegate
    ) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        setupModalStyle()
        adoptScrollViewDelegate()
        setupInitialData(
            with: imageURLs,
            index: currentPage
        )
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
        layoutInitialXPosition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.dismiss(self, at: pageControl.currentPage)
    }
    
    // MARK: Methods
    private func setupInitialData(with imageURLs: [String], index: Int) {
        Task {
            do {
                try await setImages(imageURLs: imageURLs)
                setupPageControl(total: imageURLs.count,
                                 index: index)
            } catch let error as LocalizedError {
                print(error.errorDescription ?? "\(#function) error")
            }
        }
    }
    
    private func layoutInitialXPosition() {
        let maxX = UIScreen.main.bounds.maxX
        let pageNumber = CGFloat(pageControl.currentPage)
        self.mainScrollView.contentOffset.x =  maxX * pageNumber
    }
    
    private func setupModalStyle() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
    
    @MainActor
    private func setImages(imageURLs: [String]) async throws {
        for url in imageURLs {
            let imageView = UIImageView.generate()
            imageView.clipsToBounds = false
            imageView.contentMode = .scaleAspectFit
            try await imageView.setImage(with: url)
            imageView.isUserInteractionEnabled = true
            adoptPinchGestureRecognizer(to: imageView)
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
    
    private func adoptScrollViewDelegate() {
        mainScrollView.delegate = self
    }
    
    private func adoptPinchGestureRecognizer(to imageView: UIImageView) {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(
            target: self,
            action: #selector(pinchAction(_:))
        )
        imageView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc func pageValueDidChanged(_ sender: UIPageControl) {
        let maxX = UIScreen.main.bounds.maxX
        let page = CGFloat(sender.currentPage)
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.mainScrollView.contentOffset.x =  maxX * page
        }
    }
    
    @objc private func pinchAction(_ sender: UIPinchGestureRecognizer) {
        
        guard let imageView = sender.view as? UIImageView else { return }
        
        if sender.state == .began {
            originSize = imageView.frame.size
        } else if sender.state == .changed  {
            if sender.scale < 0.7 {
                imageView.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
            } else if sender.scale > 3.0 {
                imageView.transform = CGAffineTransform.init(scaleX: 3.0, y: 3.0)
            } else {
                imageView.transform = CGAffineTransform.init(scaleX: sender.scale, y: sender.scale)
            }
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.1) {
                imageView.transform = CGAffineTransform.identity
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImageViewerViewController: UIScrollViewDelegate {
    
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
private extension ImageViewerViewController {
    
    func layoutInitialView() {
        view.addSubview(pageControl)
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(imageStackView)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            imageStackView.heightAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.heightAnchor)
        ])
    }
}
