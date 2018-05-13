//
//  OnboardingCellNode.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

protocol OnboardingCellNodeDelegate: class {

}

class OnboardingCellNode: ASCellNode {

    let type: OnboardingType
    weak var delegate: OnboardingCellNodeDelegate?

    init(type: OnboardingType, delegate: OnboardingCellNodeDelegate?) {
        self.type = type
        self.delegate = delegate
        super.init()
    }

    lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        return node
    }()

    lazy var buttonNode: ASDisplayButtonNode = {
        let node = ASDisplayButtonNode()
        node.setTitle("", with: .systemFont(ofSize: 30.adjustToScreenSize()), with: .white, for: .normal)
        node.backgroundColor = UIColor.hexStringToColor(from: "EE5549")
        node.style.flexBasis = ASDimension(unit: .points, value: 64.clasp)
        node.addTarget(self, action: #selector(wasTapped), forControlEvents: .touchUpInside)
        return node
    }()

    @objc func wasTapped(_ sender: ASButtonNode) {

    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        switch type {
        case .firstPage:
            return buttonNode.finalLayoutSpec(with: ASInsetLayoutSpec(insets: .zero, child: imageNode))
        case .lastPage:
            return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [imageNode, buttonNode])
        }
    }

}
