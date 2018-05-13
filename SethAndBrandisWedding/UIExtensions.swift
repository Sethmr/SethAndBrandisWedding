//
//  UIExtensions.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import UIKit

// MARK: - UILabel

extension UILabel {

    func adjustFontToScreenSize() {
        switch UIScreen.getDevice() {
        case .small:
            font = UIFont(name: font.fontName, size: font.pointSize * 0.7256235828)
        case .medium:
            font = UIFont(name: font.fontName, size: font.pointSize * 0.9057971014)
        case .large: break
        }
    }

}

// MARK: - UIButton

extension UIButton {

    func adjustFontToScreenSize() {
        titleLabel?.adjustFontToScreenSize()
    }

}

// MARK: - UIScreen

extension UIScreen {

    enum DeviceType {
        case small
        case medium
        case large
    }

    static func getDevice() -> DeviceType {
        switch main.bounds.size.width {
        case 320:
            return .small
        case 375:
            return .medium
        case 414:
            return .large
        default:
            return .large
        }
    }

}

// MARK: - UIViewController

extension UIViewController {

    func hideSubviews(_ hide: Bool, except: [UIView]) {
        view.subviews.forEach { subview in
            if !except.contains(subview) {
                subview.isHidden = hide
            }
        }
    }

    func getDataFromUrl(_ url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(_ url: URL, imageView: UIImageView? = nil, addBlur: Bool = false, load: ((UIImage?) -> ())? = nil) {
        getDataFromUrl(url) { data, _, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    guard let error = error else { return }
                    print("Error with Image: \(error.localizedDescription)")
                    return
                }
                var image = UIImage(data: data)
                if addBlur { image = image?.applyBlur(at: 10.clasp, tintColor: nil, saturationDeltaFactor: 1) }
                imageView?.image = image
                load?(image)
            }
        }
    }

    var safeInsets: UIEdgeInsets {
        var insets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets
        } else {
            insets.top = topLayoutGuide.length
        }
        return insets
    }

    func showAlert(title: String? = nil,
                   message: String? = nil,
                   buttonTitle: String? = nil,
                   callback: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: callback)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

extension UITabBarController {
    func hideTabBar(animated: Bool) {
        let duration = animated ? 0.5 : 0
        UIView.animate(withDuration: duration) {
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.frame.size.height)
        }
    }

    func showTabBar(animated: Bool) {
        let duration = animated ? 0.5 : 0
        UIView.animate(withDuration: duration) {
            self.tabBar.transform = .identity
        }
    }
}

// MARK: - UIImageView

extension UIImageView {

    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }

    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }

}

// MARK: - UITextField

extension UITextField {

    func adjustFontToScreenSize() {
        guard let font = font else { return }
        switch UIScreen.getDevice() {
        case .small:
            self.font = UIFont(name: font.fontName, size: font.pointSize * 0.7256235828)
        case .medium:
            self.font = UIFont(name: font.fontName, size: font.pointSize * 0.9057971014)
        case .large: break
        }
    }

    /// Moves the caret to the correct position by removing the trailing whitespace
    func fixCaretPosition() {
        let beginning = beginningOfDocument
        selectedTextRange = textRange(from: beginning, to: beginning)
        let end = endOfDocument
        selectedTextRange = textRange(from: end, to: end)
    }

}

// MARK: - UITextView

extension UITextView {

    func adjustFontToScreenSize() {
        guard let font = font else { return }
        switch UIScreen.getDevice() {
        case .small:
            self.font = UIFont(name: font.fontName, size: font.pointSize * 0.7256235828)
        case .medium:
            self.font = UIFont(name: font.fontName, size: font.pointSize * 0.9057971014)
        case .large: break
        }
    }

}

// MARK: - UIColor

extension UIColor {

    var coreImageColor: CIColor {
        return CIColor(color: self)
    }

    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }

    class func hexStringToColor(from hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func isDistinct(_ compareColor: UIColor) -> Bool {
        let (r, g, b, a) = components
        let (r1, g1, b1, a1) = compareColor.components
        let threshold1: CGFloat = 0.25
        guard fabs(r - r1) > threshold1 ||
            fabs(g - g1) > threshold1 ||
            fabs(b - b1) > threshold1 ||
            fabs(a - a1) > threshold1 else { return false }
        // check for grays, prevent multiple gray colors
        let threshold2: CGFloat = 0.03
        guard fabs( r - g ) < threshold2 &&
            fabs( r - b ) < threshold2 &&
            fabs(r1 - g1) < threshold2 &&
            fabs(r1 - b1) < threshold2 else { return true }
        return false
    }

    func isBlackOrWhite() -> Bool {
        let (r, g, b, _) = components
        // isWhite
        if r > 0.91 && g > 0.91 && b > 0.91 { return true }
        // isBlack
        if r < 0.09 && g < 0.09 && b < 0.09 { return true }
        return false
    }

    func isContrastingColor(_ color: UIColor) -> Bool {
        let (r, g, b, _) = components
        let (r2, g2, b2, _) = color.components

        let bLum: CGFloat = 0.2126 * r + 0.7152 * g + 0.0722 * b
        let fLum: CGFloat = 0.2126 * r2 + 0.7152 * g2 + 0.0722 * b2

        var contrast: CGFloat = 0.0
        if bLum > fLum {
            contrast = (bLum + 0.05) / (fLum + 0.05)
        } else {
            contrast = (fLum + 0.05) / (bLum + 0.05)
        }
        return contrast > 1.6
    }

    class func gradientColor(withSize size: CGSize,
                             startColor: UIColor,
                             endColor: UIColor,
                             startLocation: CGFloat = 0,
                             endLocation: CGFloat = 1) -> UIColor? {
        guard let gradientImage = UIImage.gradientImage(withSize: size,
                                                     startColor: startColor,
                                                     endColor: endColor,
                                                     startLocation: startLocation,
                                                     endLocation: endLocation) else { return nil }
        return UIColor(patternImage: gradientImage)
    }

    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
            guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }

            return UIColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
}

// MARK: - String

extension String {

    func gradientImage(withFont font: UIFont,
                       startColor: UIColor,
                       endColor: UIColor,
                       startLocation: CGFloat = 0,
                       endLocation: CGFloat = 1) -> UIImage? {
        let textSize = self.size(withAttributes: [.font: font])
        return UIImage.gradientImage(withSize: textSize,
                                     startColor: startColor,
                                     endColor: endColor,
                                     startLocation: startLocation,
                                     endLocation: endLocation)
    }

    func gradientColor(withFont font: UIFont,
                       startColor: UIColor,
                       endColor: UIColor,
                       startLocation: CGFloat = 0,
                       endLocation: CGFloat = 1) -> UIColor? {

        let textSize = self.size(withAttributes: [.font: font])
        return UIColor.gradientColor(withSize: textSize,
                                     startColor: startColor,
                                     endColor: endColor,
                                     startLocation: startLocation,
                                     endLocation: endLocation)
    }

}

// MARK: - CGFloat

extension CGFloat {

    func adjustToScreenSize() -> CGFloat {
        switch UIScreen.getDevice() {
        case .small:
            return self * 0.7729468599
        case .medium:
            return self * 0.9057971014
        case .large:
            return self
        }
    }

}

// MARK: - UIRectCorner

extension UIRectCorner {

    static let top: UIRectCorner = [UIRectCorner.topLeft, UIRectCorner.topRight]
    static let left: UIRectCorner = [UIRectCorner.bottomLeft, UIRectCorner.topLeft]
    static let right: UIRectCorner = [UIRectCorner.topRight, UIRectCorner.bottomRight]
    static let bottom: UIRectCorner = [UIRectCorner.bottomRight, UIRectCorner.bottomLeft]

}

// MARK: - UIView

extension UIView {

    func screenshot() -> UIImage? {
        if self is UIScrollView {
            guard let scrollView = self as? UIScrollView else { return nil }

            let savedContentOffset = scrollView.contentOffset
            let savedFrame = scrollView.frame

            UIGraphicsBeginImageContext(scrollView.contentSize)
            scrollView.contentOffset = .zero
            frame = CGRect(
                x: 0,
                y: 0,
                width: scrollView.contentSize.width,
                height: scrollView.contentSize.height
            )
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            layer.render(in: context)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()

            scrollView.contentOffset = savedContentOffset
            scrollView.frame = savedFrame

            return image
        } else {
            UIGraphicsBeginImageContext(bounds.size)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            self.layer.render(in: context)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            return image
        }
    }
//
//    func loadImage(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
//        guard let url = URL(string: urlString) else {
//            return closure(nil)
//        }
//        SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil) { (image, _, error, _, _, _) in
//            if let error = error {
//                print(error)
//            }
//            closure(image)
//        }
//    }

}

// MARK: - CALayer

extension CALayer {

    var belongsToScrollView: Bool {
        if let delegate = self.delegate, delegate is UIScrollView {
            return true
        }
        return false
    }

    var copy: CALayer? {
        let tmp = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: tmp) as? CALayer
    }

    var contentsImage: CGImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)

        return renderer.image { context in
            return self.render(in: context.cgContext)
        }.cgImage
    }

}
