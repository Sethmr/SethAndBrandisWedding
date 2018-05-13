//
//  ScavengerHuntDescriptionViewController.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

class ScavengerHuntDescriptionViewController: ASViewController<ASDisplayNode>, UINavigationControllerDelegate {

    let task: ScavengerTask
    let dismissBlock: () -> ()

    init(task: ScavengerTask, dismissBlock: @escaping () -> ()) {
        self.task = task
        self.dismissBlock = dismissBlock
        super.init(node: ASDisplayNode())
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = UIColor.mainColor
        node.layoutSpecBlock = { [unowned self] _, _ in
            let arrowSpec = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: .minimumSize, child: self.arrowNode)
            let titleSpec = ASRelativeLayoutSpec(horizontalPosition: .center, verticalPosition: .start, sizingOption: .minimumSize, child: self.titleNode)
            let overlaySpec = ASOverlayLayoutSpec(child: self.imageNode, overlay: self.buttonNode)
            overlaySpec.style.spacingBefore = 92.clasp + ViewController.safeInsets.top
            let stackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 38.clasp, justifyContent: .start, alignItems: .center, children: [overlaySpec, self.subtitleNode])
            return ASWrapperLayoutSpec(layoutElements: [arrowSpec, titleSpec, stackSpec])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }

    lazy var imageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.style.preferredLayoutSize = ASLayoutSize(
            width: ASDimension(unit: .points, value: 334.clasp),
            height: ASDimension(unit: .points, value: 334.clasp))

        node.url = URL(string: task.imageUrl)
        node.defaultImage = #imageLiteral(resourceName: "DefaultImage")
        return node
    }()

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

    @objc func backWasTapped(_ sender: ASButtonNode) {
        dismissBlock()
    }

    lazy var buttonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.addTarget(self, action: #selector(wasTapped), forControlEvents: .touchUpInside)
        return node
    }()

    @objc func wasTapped(_ sender: ASButtonNode) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.popoverPresentationController?.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            present(imagePicker, animated: true, completion: nil)
        }
    }

    lazy var titleNode: ASTextNode = {
        let node = ASTextNode()
        let string = NSAttributedString(
            string: task.title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 27.adjustToScreenSize(), weight: .semibold),
                .foregroundColor: UIColor.white
            ]
        )
        node.attributedText = string
        let width: CGFloat = 286.clasp
        node.style.maxWidth = ASDimension(unit: .points, value: width)
        node.maximumNumberOfLines = 2
        if string.size().width > width {
            node.textContainerInset.top = 3.clasp + ViewController.safeInsets.top
        } else {
            node.textContainerInset.top = 20.clasp + ViewController.safeInsets.top
        }
        return node
    }()

    lazy var subtitleNode: ASTextNode = {
        let node = ASTextNode()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9.clasp
        node.attributedText = NSAttributedString(
            string: task.subtitle,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15.adjustToScreenSize(), weight: .medium),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
        node.maximumNumberOfLines = 0
        node.style.width = ASDimension(unit: .points, value: 334.clasp)
        return node
    }()
}

// MARK: - UIPopoverPresentationControllerDelegate

extension ScavengerHuntDescriptionViewController: UIPopoverPresentationControllerDelegate {

    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {}
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {}

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }

    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController,
                                       willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>,
                                       in view: AutoreleasingUnsafeMutablePointer<UIView>) {}

}

// MARK: - UIImagePickerControllerDelegate

extension ScavengerHuntDescriptionViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var image: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = originalImage
        }
        imageNode.image = image
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

}
