//
//  VimvestFontStyleGuide.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import UIKit

extension UIFont {

    enum MontserratWeight: String {
        case bold = "Montserrat-Bold"
        case light = "Montserrat-Light"
        case medium = "Montserrat-Medium"
        case semibold = "Montserrat-SemiBold"
        case regular = "Montserrat-Regular"
        case extraBold = "Montserrat-ExtraBold"
    }

    class func montserratFont(ofSize fontSize: CGFloat, weight: MontserratWeight = .regular) -> UIFont {
        return UIFont(name: weight.rawValue, size: fontSize)!
    }

}

extension NSShadow {

    class var mainShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.5)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 1
        return shadow
    }

    class func shadow(withAlpha alpha: CGFloat, radius: CGFloat = 1, offsetHeight: CGFloat = 1) -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(alpha)
        shadow.shadowOffset = CGSize(width: 0, height: offsetHeight)
        shadow.shadowBlurRadius = radius
        return shadow
    }

}
