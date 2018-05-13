//
//  CoverHorizontalPresentAnimationController.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import UIKit

class CoverHorizontalPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        toVC.view.layer.transform = CATransform3DMakeTranslation(UIScreen.main.bounds.width, 0, 0)
        containerView.addSubview(toVC.view)
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                toVC.view.layer.transform = CATransform3DIdentity
            },
            completion: { _ in
                if transitionContext.transitionWasCancelled {
                    toVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
