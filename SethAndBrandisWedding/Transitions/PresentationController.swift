//
//  PresentationController.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {

    override func presentationTransitionWillBegin() {
        presentingViewController.beginAppearanceTransition(false, animated: true)
        presentedViewController.beginAppearanceTransition(true, animated: true)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
        presentedViewController.endAppearanceTransition()
    }

    override func dismissalTransitionWillBegin() {
        presentingViewController.beginAppearanceTransition(true, animated: true)
        presentedViewController.beginAppearanceTransition(false, animated: true)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
        presentedViewController.endAppearanceTransition()
    }

}
