//
//  ScavengerHuntCellNode.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

protocol ScavengerHuntCellNodeDelegate: class {
    func cellWasTapped(with task: ScavengerTask)
}

class ScavengerHuntCellNode: ASCellNode {

    let task: ScavengerTask
    weak var delegate: ScavengerHuntCellNodeDelegate?

    init(task: ScavengerTask, delegate: ScavengerHuntCellNodeDelegate?) {
        self.task = task
        self.delegate = delegate
        super.init()
        automaticallyManagesSubnodes = true
        backgroundColor = .white
        selectionStyle = .none
    }

    lazy var imageNode: ASNetworkImageNode? = {
        guard let url = URL(string: task.imageUrl) else { return nil }
        let node = ASNetworkImageNode()
        node.url = URL(string: task.imageUrl)
        node.style.preferredLayoutSize = ASLayoutSize(
            width: ASDimension(unit: .points, value: 80.clasp),
            height: ASDimension(unit: .points, value: 80.clasp)
        )
        node.style.spacingBefore = 10.clasp
        return node
    }()

    lazy var arrowNode: ASImageNode = {
        let node = ASImageNode()
        node.image = task.isCompleted ? #imageLiteral(resourceName: "HeartArrow") : #imageLiteral(resourceName: "SmallForwardIcon")
        node.style.preferredLayoutSize = ASLayoutSize(
            width: ASDimension(unit: .points, value: (task.isCompleted ? 20 : 7).clasp),
            height: ASDimension(unit: .points, value: (task.isCompleted ? 20 : 11).clasp)
        )
        return node
    }()

    lazy var titleNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(
            string: task.title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 20.adjustToScreenSize(), weight: .semibold),
                .foregroundColor: UIColor.mainColor
            ]
        )
        node.maximumNumberOfLines = 1
        if URL(string: task.imageUrl) != nil {
            node.style.maxWidth = ASDimension(unit: .points, value: 273.clasp)
        } else {
            node.style.maxWidth = ASDimension(unit: .points, value: 365.clasp)
        }
        return node
    }()

    lazy var subtitleNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(
            string: task.subtitle,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14.adjustToScreenSize(), weight: .medium),
                .foregroundColor: UIColor.mainColor
            ]
        )
        node.maximumNumberOfLines = 2
        if URL(string: task.imageUrl) != nil {
            node.style.maxWidth = ASDimension(unit: .points, value: 279.clasp)
        } else {
            node.style.maxWidth = ASDimension(unit: .points, value: 365.clasp)
        }
        return node
    }()

    lazy var buttonNode: ASDisplayButtonNode = {
        let node = ASDisplayButtonNode()
        node.addTarget(self, action: #selector(cellWasTapped), forControlEvents: .touchUpInside)
        return node
    }()

    @objc func cellWasTapped(_ sender: ASButtonNode) {
        delegate?.cellWasTapped(with: task)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textStack = ASStackLayoutSpec(direction: .vertical, spacing: 5.clasp, justifyContent: .center, alignItems: .start, children: [titleNode, subtitleNode])
        textStack.flexWrap = .wrap
        var finalSpec: ASLayoutSpec
        if let imageNode = imageNode {
            let ratioSpec = ASRatioLayoutSpec(ratio: 1, child: imageNode)
            finalSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 8.clasp, justifyContent: .start, alignItems: .center, children: [ratioSpec, textStack])
        } else {
            finalSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16.clasp, bottom: 0, right: 0), child: textStack)
        }
        let relativeSpec = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .center, sizingOption: .minimumSize, child: arrowNode)
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16.clasp), child: relativeSpec)
        return buttonNode.finalLayoutSpec(with: ASWrapperLayoutSpec(layoutElements: [finalSpec, insetSpec]))
    }

}
