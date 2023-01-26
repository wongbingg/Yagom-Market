//
//  ImageViewerTransitioningDelegate.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/25.
//

import UIKit

final class ImageViewerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return ImageViewerPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
