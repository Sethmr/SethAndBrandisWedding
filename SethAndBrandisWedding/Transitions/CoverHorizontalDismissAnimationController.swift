//
//  CoverHorizontalDismissAnimationController.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import UIKit

class CoverHorizontalDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }

        let duration = transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                fromVC.view.layer.transform = CATransform3DMakeTranslation(UIScreen.main.bounds.width, 0, 0)
            },
            completion: { _ in
//                snapshot.removeFromSuperview()
                if !transitionContext.transitionWasCancelled {
                    fromVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

}
