//
//  SettingsViewController.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/14/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import UIKit

class SettingsViewController: ASViewController<ASDisplayNode> {

    let dismissSelf: () -> ()

    init(dismissSelf: @escaping () -> ()) {
        self.dismissSelf = dismissSelf
        super.init(node: ASDisplayNode())
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = .mainColor
        node.layoutSpecBlock = { [unowned self] _, _ in
            let spec = ASStackLayoutSpec(direction: .vertical, spacing: 10.clasp, justifyContent: .center, alignItems: .start, children: [self.titleNode, self.subtitleNode, self.methodsNode, self.paymentsNode])
            let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 20).clasp, child: spec)
            let relativeSpec = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: .minimumSize, child: self.arrowNode)
            return ASOverlayLayoutSpec(child: insetSpec, overlay: relativeSpec)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Not Supported")
    }

    lazy var arrowNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(#imageLiteral(resourceName: "BackArrowIcon"), for: .normal)
        node.imageNode.style.preferredLayoutSize = ASLayoutSize(
            width: ASDimension(unit: .points, value: 12.clasp),
            height: ASDimension(unit: .points, value: 19.clasp)
        )
        node.style.preferredLayoutSize = ASLayoutSize(
            width: ASDimension(unit: .points, value: 64.clasp),
            height: ASDimension(unit: .points, value: ViewController.safeInsets.top + 73.clasp)
        )
        node.contentEdgeInsets.top = ViewController.safeInsets.top
        node.addTarget(self, action: #selector(backWasTapped), forControlEvents: .touchUpInside)
        return node
    }()

    lazy var titleNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(
            string: "HONEYMOON FUND",
            attributes: [
                .font: UIFont.systemFont(ofSize: 27.adjustToScreenSize(), weight: .heavy),
                .foregroundColor: UIColor.white
            ]
        )
        node.maximumNumberOfLines = 1
        return node
    }()

    lazy var subtitleNode: ASTextNode = {
        let node = ASTextNode()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.clasp
        node.attributedText = NSAttributedString(
            string: "Help Seth and Brandi on there honeymoon. Every penny helps and it has never been easier to help out.",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16.adjustToScreenSize(), weight: .medium),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
        node.maximumNumberOfLines = 3
        node.style.spacingAfter = 30.clasp
        return node
    }()

    lazy var methodsNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(
            string: "METHODS OF PAYMENT:",
            attributes: [
                .font: UIFont.systemFont(ofSize: 27.adjustToScreenSize(), weight: .heavy),
                .foregroundColor: UIColor.white
            ]
        )
        node.maximumNumberOfLines = 1
        return node
    }()

    lazy var paymentsNode: ASTextNode = {
        let node = ASTextNode()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.clasp
        node.attributedText = NSAttributedString(
            string: """
            Venmo - Seth Rininger @Seth-Rininger\n\
            Venmo - Brandi Chavez @Brandi-Chavez-3\n\
            Bank of America App - sethmr21@gmail.com\n\
            Paypal - Seth Rininger/sethmr21@gmail.com\n\
            iMessage - 731-610-1638\n\
            Cash
            """,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16.adjustToScreenSize(), weight: .medium),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
        node.maximumNumberOfLines = 6
        node.style.spacingAfter = 30.clasp
        return node
    }()

    @objc func backWasTapped(_ sender: ASButtonNode) {
        dismissSelf()
    }

}
