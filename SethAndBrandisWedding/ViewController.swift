//
//  ViewController.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

class ViewController: UIViewController {

    static var safeInsets: UIEdgeInsets = .zero
    static var screenWidth: CGFloat = 0
    static let userDefaults = UserDefaults(suiteName: "group.seth")!

    enum Key: String {
        case name
    }

    static var name: String? {
        get { return userDefaults[.name] }
        set { userDefaults[.name] = newValue }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViewController.safeInsets = safeInsets
        ViewController.screenWidth = UIScreen.main.bounds.width
        if ViewController.name != nil {
            let vc = ScavengerHuntViewController()
            present(vc, animated: true)
        } else {
            let vc = OnboardingViewController()
            present(vc, animated: false)
        }
    }


}

extension UserDefaults {
    subscript(_ key: ViewController.Key) -> String? {
        get {
            return string(forKey: key.rawValue)
        }
        set {
            set(newValue, forKey: key.rawValue)
        }
    }
}

