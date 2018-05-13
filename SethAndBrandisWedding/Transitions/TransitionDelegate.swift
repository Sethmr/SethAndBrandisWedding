//
//  TransitionDelegate.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var dismissBlock: (() -> ())?
    static var shared = TransitionDelegate()

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CoverHorizontalPresentAnimationController()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissBlock?()
        dismissBlock = nil
        return CoverHorizontalDismissAnimationController()
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }

}
