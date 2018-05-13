//
//  ASDisplayButtonNode.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

class ASDisplayButtonNode: ASDisplayNode {

    fileprivate let wasTapped: (() -> ())?

    override var hitTestSlop: UIEdgeInsets {
        get {
            return buttonNode.hitTestSlop
        }
        set {
            buttonNode.hitTestSlop = hitTestSlop
        }
    }

    var isEnabled: Bool {
        get {
            return buttonNode.isEnabled
        }
        set {
            buttonNode.isEnabled = newValue
        }
    }

    init(wasTapped: (() -> ())? = nil) {
        self.wasTapped = wasTapped
        super.init()
    }

    lazy var buttonNode: ASButtonNode = {
        let node = ASButtonNode()
        if wasTapped != nil {
            node.addTarget(self, action: #selector(buttonWasTapped), forControlEvents: .touchUpInside)
        }
        return node
    }()

    @objc func buttonWasTapped(_ sender: ASButtonNode) {
        wasTapped?()
    }

    public func addTarget(_ target: Any?, action: Selector, forControlEvents: ASControlNodeEvent) {
        buttonNode.addTarget(target, action: action, forControlEvents: forControlEvents)
    }

    // Return this function in your layoutSpecBlock always when implementing this class
    public func finalLayoutSpec(with layoutSpec: ASLayoutSpec) -> ASLayoutSpec {
        return ASOverlayLayoutSpec(child: layoutSpec, overlay: buttonNode)
    }

    // Alternative for having the button in the background
    public func backgroundLayoutSpec(with layoutSpec: ASLayoutSpec) -> ASLayoutSpec {
        return ASBackgroundLayoutSpec(child: layoutSpec, background: buttonNode)
    }

}
