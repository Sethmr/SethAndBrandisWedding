//
//  ViewController.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

class ViewController: UIViewController {

    static var name: String = ""
    static var safeInsets: UIEdgeInsets = .zero
    static var screenWidth: CGFloat = 0

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViewController.safeInsets = safeInsets
        ViewController.screenWidth = UIScreen.main.bounds.width
        let vc = OnboardingViewController()
        present(vc, animated: false)
    }


}

