//
//  ScavengerHuntHeaderCellNode.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

class ScavengerHuntHeaderCellNode: ASCellNode {

    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        backgroundColor = UIColor.mainColor
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.tasksUpdated),
            name: NSNotification.Name("tasksUpdated"),
            object: nil
        )
    }

    @objc func tasksUpdated(_ notification: Notification) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        countNode.attributedText = NSAttributedString(
            string: "\(ScavengerTask.completedCount) completed out of \(ScavengerTask.tasks.count)",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16.adjustToScreenSize(), weight: .light),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
    }

    lazy var titleNode: ASTextNode = {
        let node = ASTextNode()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        node.attributedText = NSAttributedString(
            string: "Scavenger Hunt",
            attributes: [
                .font: UIFont.systemFont(ofSize: 38.adjustToScreenSize(), weight: .semibold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
        node.maximumNumberOfLines = 1
        return node
    }()

    lazy var subtitleNode: ASTextNode = {
        let node = ASTextNode()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9.clasp
        node.attributedText = NSAttributedString(
            string: "Help Seth and Brandi hold onto every moment!\nThank you for capturing the best day of our lives.",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16.adjustToScreenSize(), weight: .medium),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
        node.maximumNumberOfLines = 2
        node.style.maxWidth = ASDimension(unit: .points, value: 365.clasp)
        node.style.spacingAfter = 16.clasp
        return node
    }()

    lazy var countNode: ASTextNode = {
        let node = ASTextNode()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        node.attributedText = NSAttributedString(
            string: "\(ScavengerTask.completedCount) completed out of \(ScavengerTask.tasks.count)",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16.adjustToScreenSize(), weight: .light),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
        node.maximumNumberOfLines = 2
        node.style.maxWidth = ASDimension(unit: .points, value: 365.clasp)
        return node
    }()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: 20.clasp, justifyContent: .start, alignItems: .stretch, children: [titleNode, subtitleNode, countNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 18, bottom: 0, right: 18).clasp, child: stack)
    }
}
