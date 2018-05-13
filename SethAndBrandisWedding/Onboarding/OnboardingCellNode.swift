//
//  OnboardingCellNode.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

protocol OnboardingCellNodeDelegate: class {
    func wasTapped(type: OnboardingType, with text: String?)
}

class OnboardingCellNode: ASCellNode {

    var isKeyboardVisible: Bool = false
    var isKeyboardUp: Bool = false
    var keyboardHeight: CGFloat = 0
    let type: OnboardingType
    var text: String {
        return editableTextNode.attributedText?.string ?? ""
    }
    weak var delegate: OnboardingCellNodeDelegate?

    init(type: OnboardingType, delegate: OnboardingCellNodeDelegate?) {
        self.type = type
        self.delegate = delegate
        super.init()
        selectionStyle = .none
        automaticallyManagesSubnodes = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }

    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        editableTextNode.becomeFirstResponder()
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard !isKeyboardVisible else { return }
        keyboardHeight = notification.keyboardEndFrame.height
        isKeyboardUp = true
        setNeedsLayout()
        UIView.animate(
            withDuration: notification.animationDuration,
            delay: 0,
            options: notification.animationOptions,
            animations: { self.layoutIfNeeded() }
        )
    }


    @objc func keyboardWillHide(_ notification: Notification) {
        guard isKeyboardVisible else { return }
        isKeyboardUp = false
        setNeedsLayout()
        UIView.animate(
            withDuration: notification.animationDuration,
            delay: 0,
            options: notification.animationOptions,
            animations: { self.layoutIfNeeded() }
        )
    }

    @objc func keyboardDidShow(_ notification: Notification) {
        isKeyboardVisible = true
    }

    @objc func keyboardDidHide(_ notification: Notification) {
        isKeyboardVisible = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard type == .lastPage, let touchedView = touches.first?.view,
                !touchedView.isMember(of: ASButtonNode.self) else { return }
        if isKeyboardVisible {
            editableTextNode.resignFirstResponder()
        } else {
            editableTextNode.becomeFirstResponder()
        }
    }

    lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = type.image
        node.style.flexGrow = 1
        node.style.flexShrink = 1
        node.contentMode = .scaleAspectFill
        return node
    }()

    lazy var textNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.attributedText = NSAttributedString(
            string: "Enter Full Name",
            attributes: [
                .font: UIFont.systemFont(ofSize: 34.adjustToScreenSize(), weight: .heavy),
                .foregroundColor: UIColor.white
            ]
        )
        node.style.spacingBefore = ViewController.safeInsets.top + 100.clasp
        node.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        node.shadowOffset = CGSize(width: 0, height: 3.clasp)
        node.shadowRadius = 1
        node.shadowOpacity = 1
        return node
    }()

    lazy var editableTextNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.attributedPlaceholderText = NSAttributedString(
            string: "First Last",
            attributes: [
                .font: UIFont.systemFont(ofSize: 24.adjustToScreenSize(), weight: .medium),
                .foregroundColor: UIColor.lightGray,
                .shadow: NSShadow.mainShadow
            ]
        )
        node.typingAttributes = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 24.adjustToScreenSize(), weight: .light)
        ]
        node.style.width = ASDimension(unit: .points, value: 280.clasp)
        node.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        node.shadowOffset = CGSize(width: 0, height: 3.clasp)
        node.shadowRadius = 1
        node.shadowOpacity = 1
        node.style.spacingBefore = 34.clasp
        node.delegate = self
        return node
    }()

    lazy var barNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.white
        node.style.flexBasis = ASDimension(unit: .points, value: 2.clasp)
        node.style.width = ASDimension(unit: .points, value: 280.clasp)
        node.cornerRadius = 2.clasp / 2
        node.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        node.shadowOffset = CGSize(width: 0, height: 1)
        node.shadowRadius = 1
        node.shadowOpacity = 1
        return node
    }()

    lazy var buttonNode: ASDisplayButtonNode = {
        let node = ASDisplayButtonNode()
        if type == .lastPage {
            node.isEnabled = false
            node.buttonNode.setTitle("CONTINUE", with: .systemFont(ofSize: 30.adjustToScreenSize(), weight: .heavy), with: .mainColor, for: .normal)
            node.buttonNode.backgroundColor = UIColor.white
            node.buttonNode.style.spacingAfter = isKeyboardUp ? keyboardHeight : 0
            node.buttonNode.style.flexBasis = ASDimension(unit: .points, value: 64.clasp + (isKeyboardUp ? 0 : ViewController.safeInsets.bottom))
            node.buttonNode.contentEdgeInsets.bottom = isKeyboardUp ? 0 : ViewController.safeInsets.bottom
        }
        node.addTarget(self, action: #selector(wasTapped), forControlEvents: .touchUpInside)
        return node
    }()

    @objc func wasTapped(_ sender: ASButtonNode) {
        let text: String? = type == .lastPage ? self.text : nil
        delegate?.wasTapped(type: type, with: text)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        switch type {
        case .firstPage:
            return buttonNode.finalLayoutSpec(with: ASInsetLayoutSpec(insets: .zero, child: imageNode))
        case .lastPage:
            buttonNode.buttonNode.style.spacingAfter = isKeyboardUp ? keyboardHeight : 0
            buttonNode.buttonNode.style.flexBasis = ASDimension(unit: .points, value: 64.clasp + (isKeyboardUp ? 0 : ViewController.safeInsets.bottom))
            buttonNode.buttonNode.contentEdgeInsets.bottom = isKeyboardUp ? 0 : ViewController.safeInsets.bottom
            let textStack = ASStackLayoutSpec(direction: .vertical, spacing: 2.clasp, justifyContent: .start, alignItems: .start, children: [textNode, editableTextNode, barNode])
            let relativeSpec = ASRelativeLayoutSpec(horizontalPosition: .center, verticalPosition: .start, sizingOption: .minimumSize, child: textStack)
            let mainStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [imageNode, buttonNode.buttonNode])
            return ASOverlayLayoutSpec(child: mainStack, overlay: relativeSpec)
        }
    }

}

extension OnboardingCellNode: ASEditableTextNodeDelegate {

    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if self.text.count > 2 {
                delegate?.wasTapped(type: type, with: self.text)
            }
            return false
        }
        let newText = (editableTextNode.textView.text as NSString).replacingCharacters(in: range, with: text)
        let buttonEnabled = newText.count > 2
        buttonNode.isEnabled = buttonEnabled
        buttonNode.buttonNode.backgroundColor = buttonEnabled ? UIColor.mainColor : UIColor.white
        buttonNode.buttonNode.setTitle("CONTINUE", with: .systemFont(ofSize: 30.adjustToScreenSize(), weight: .heavy), with: buttonEnabled ? .white : .mainColor, for: .normal)
        return true
    }

}
