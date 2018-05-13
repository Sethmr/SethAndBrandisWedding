//
//  OnboardingViewController.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

class OnboardingViewController: ASViewController<ASPagerNode> {

    let types: [OnboardingType] = OnboardingType.allTypes

    init() {
        super.init(node: ASPagerNode())
        node.setDelegate(self)
        node.setDataSource(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Not Supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        node.reloadData()
    }

}

extension OnboardingViewController: ASPagerDelegate {

    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return types.count
    }
}

extension OnboardingViewController: ASPagerDataSource {

    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let type = types[index]
        return { return OnboardingCellNode(type: type, delegate: self) }
    }
}

extension OnboardingViewController: OnboardingCellNodeDelegate {

    func wasTapped(type: OnboardingType, with text: String?) {
        let nextPage = type.rawValue + 1
        if nextPage < types.count {
            node.scrollToPage(at: nextPage, animated: true)
        } else {
            guard let text = text else { fatalError() }
            ViewController.name = text
            let vc = ScavengerHuntViewController()
            present(vc, animated: true)
        }
    }

}

