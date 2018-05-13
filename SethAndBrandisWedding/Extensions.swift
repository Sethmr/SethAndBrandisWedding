//
//  Extensions.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity

import Foundation

func delayOnMainThread(_ delay: Double, block: @escaping () -> Void ) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when) {
        block()
    }
}

// MARK: - DispatchQueue

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->())? = nil, completion: (()->())? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    completion()
                }
            }
        }
    }

}

// MARK: - UIEdgeInsets

extension UIEdgeInsets {

    func adjustToScreenSize() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.adjustToScreenSize(),
            left: left.adjustToScreenSize(),
            bottom: bottom.adjustToScreenSize(),
            right: right.adjustToScreenSize()
        )
    }

    func pixelRound() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.pixelRound(),
            left: left.pixelRound(),
            bottom: bottom.pixelRound(),
            right: right.pixelRound()
        )
    }

    var clasp: UIEdgeInsets {
        return UIEdgeInsets(
            top: top.clasp,
            left: left.clasp,
            bottom: bottom.clasp,
            right: right.clasp
        )
    }

    public static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right)
    }

    public static func += (left: inout UIEdgeInsets, right: UIEdgeInsets) {
        left.top += right.top
        left.bottom += right.bottom
        left.left += right.left
        left.right += right.right
    }

    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

}

// MARK: - CGRect

extension CGRect {

    func adjustToScreenSize() -> CGRect {
        return CGRect(
            x: origin.x.adjustToScreenSize(),
            y: origin.y.adjustToScreenSize(),
            width: width.adjustToScreenSize(),
            height: height.adjustToScreenSize()
        )
    }

    func pixelRound() -> CGRect {
        return CGRect(
            x: origin.x.pixelRound(),
            y: origin.y.pixelRound(),
            width: width.pixelRound(),
            height: height.pixelRound()
        )
    }

    var clasp: CGRect {
        return CGRect(
            x: origin.x.clasp,
            y: origin.y.clasp,
            width: width.clasp,
            height: height.clasp
        )
    }

    public var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    public func edgeInsets(to outerRect: CGRect) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: outerRect.origin.y - origin.y,
            left: outerRect.origin.x - origin.x,
            bottom: maxY - outerRect.maxY,
            right: maxX - outerRect.maxX)
    }

}

// MARK: - CGSize

extension CGSize {

    func adjustToScreenSize() -> CGSize {
        return CGSize(
            width: width.adjustToScreenSize(),
            height: height.adjustToScreenSize()
        )
    }

    func pixelRound() -> CGSize {
        return CGSize(
            width: width.pixelRound(),
            height: height.pixelRound()
        )
    }

    var clasp: CGSize {
        return CGSize(
            width: width.clasp,
            height: height.clasp
        )
    }
}

// MARK: - CGPoint

extension CGPoint {

    func adjustToScreenSize() -> CGPoint {
        return CGPoint(
            x: x.adjustToScreenSize(),
            y: y.adjustToScreenSize()
        )
    }

    func pixelRound() -> CGPoint {
        return CGPoint(
            x: x.pixelRound(),
            y: y.pixelRound()
        )
    }

    var clasp: CGPoint {
        return CGPoint(
            x: x.clasp,
            y: y.clasp
        )
    }

}

// MARK: - String

extension String {

    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let supportedFormats = [
            "yyyy-MM-dd'T'HH:mm:s'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z"
        ]
        for format in supportedFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: self) {
                return date
            }
        }
        return nil
    }

    private static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()

    private var decimalSeparator: String {
        return String.decimalFormatter.decimalSeparator ?? "."
    }

    func isValidDecimal(maximumFractionDigits: Int) -> Bool {

        // Depends on you if you consider empty string as valid number
        guard self.isEmpty == false else {
            return true
        }

        // Check if valid decimal
        if String.decimalFormatter.number(from: self) != nil {
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 2 ? numberComponents.last ?? "" : ""
            return fractionDigits.count <= maximumFractionDigits
        }

        return false
    }

    var numbersOnly: String {
        return self.filter { "0123456789".contains($0) }
    }

}

// MARK: - Date

public extension Date {

    var formattedYear: String? {
        return toString(with: "yyyy")
    }

    var dayName: String? {
        return toString(with: "EEEE")
    }

    func toString(with format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func toShortApiString() -> String {
        return toString(with: "yyyy-MM-dd")
    }

    func toApiString() -> String {
        return toString(with: "yyyy-MM-dd'T'HH:mm:ss'Z'")
    }

    func toPrettyString() -> String {
        return toString(with: "MMMM dd, yyyy")
    }

    func toMonthYear() -> String {
        return toString(with: "MMMM yyyy")
    }

    func toShortString() -> String {
        return toString(with: "M/d")
    }

    func timeAgoSinceDate() -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = (earliest == now as Date) ? self : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date, to: latest as Date)

        switch components.year! {
        case 2..<Int.max:
            return "\(components.year!) years ago"
        case 1..<2:
            return "1 year ago"
        default:

        switch components.month! {
        case 2..<Int.max:
            return "\(components.month!) months ago"
        case 1..<2:
            return "1 month ago"
        default:

        switch components.weekOfYear! {
        case 2..<Int.max:
            return "\(components.weekOfYear!) weeks ago"
        case 1..<2:
            return "1 week ago"
        default:

        switch components.day! {
        case 2..<Int.max:
            return "\(components.day!) days ago"
        case 1..<2:
            return "1 day ago"
        default:

        switch components.hour! {
        case 2..<Int.max:
            return "\(components.hour!) hours ago"
        case 1..<2:
            return "1 hour ago"
        default:

        switch components.minute! {
        case 2..<Int.max:
            return "\(components.minute!) minutes ago"
        case 1..<2:
            return "1 minute ago"
        default:
            if components.second! >= 3 {
                return "\(components.second!) seconds ago"
            } else {
                return "Just now"
            }
        }
    }
}}}}}}

// MARK: - NumberFormatLetter

enum NumberFormatLetter: String {

    case trillion = "T"
    case billion = "B"
    case million = "M"
    case thousand = "K"
    case empty = ""

}

// MARK: - Int

extension Int {

    internal func toChangedAmount() -> String {
        switch self {
        case 1..<Int.max:
            return "+\(self)"
        case 0:
            return ""
        case Int.min..<0:
            return "\(self)"
        default:
            return ""
        }
    }

    var prettyString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    var formattedCurrency: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return numberFormatter.string(from: self as NSNumber)
    }

    func adjustToScreenSize() -> CGFloat {
        return CGFloat(self).adjustToScreenSize()
    }

    var cgf: CGFloat { return CGFloat(self) }
    var f: Float {return Float(self) }
    var d: Double { return Double(self) }
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
    var clasp: CGFloat { return CGFloat(self).adjustToScreenSize().pixelRound() }

}

// MARK: - Double

extension Double {

    func toOneDecimalPlaces() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }

    public func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? ""
    }

    public func appFormatted(withPlus: Bool) -> String {

        let formatter: NumberFormatter!
        var number: Double!
        var letter: NumberFormatLetter!

        switch self {
        case 10000000000000..<Double.infinity:
            number = self / 1000000000000
            letter = .trillion
            formatter = simpleNumberFormatter()
        case 1000000000000..<10000000000000:
            number = self / 1000000000000
            letter = .trillion
            formatter = number.truncatingRemainder(dividingBy: 1) >= 0.05 ? singleDigitNumberFormatter() : simpleNumberFormatter()
        case 10000000000..<1000000000000:
            number = self / 1000000000
            letter = .billion
            formatter = simpleNumberFormatter()
        case 1000000000..<10000000000:
            number = self / 1000000000
            letter = .billion
            formatter = number.truncatingRemainder(dividingBy: 1) >= 0.05 ? singleDigitNumberFormatter() : simpleNumberFormatter()
        case 10000000..<1000000000:
            number = self / 1000000
            letter = .million
            formatter = simpleNumberFormatter()
        case 1000000..<10000000:
            number = self / 1000000
            letter = .million
            formatter = number.truncatingRemainder(dividingBy: 1) >= 0.05 ? singleDigitNumberFormatter() : simpleNumberFormatter()
        case 10000..<1000000:
            number = self / 1000
            letter = .thousand
            formatter = simpleNumberFormatter()
        case 1000..<10000:
            number = self / 1000
            letter = .thousand
            formatter = number.truncatingRemainder(dividingBy: 1) >= 0.05 ? singleDigitNumberFormatter() : simpleNumberFormatter()
        default:
            number = self
            letter = .empty

            formatter = simpleNumberFormatter()
        }

        guard let numberString = formatter.string(from: NSNumber(value: number)) else { return "" }
        return "\(numberString)\(letter.rawValue)\(withPlus ? "+" : "")"
    }

    private func singleDigitNumberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }

    private func simpleNumberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }

    func adjustToScreenSize() -> CGFloat {
        return CGFloat(self).adjustToScreenSize()
    }

    var clasp: CGFloat { return CGFloat(self).adjustToScreenSize().pixelRound() }
    var cgf: CGFloat { return CGFloat(self) }
    var f: Float {return Float(self) }
    var i: Int { return Int(self) }

}

// MARK: - Float

extension Float {
    var clasp: CGFloat { return CGFloat(self).adjustToScreenSize().pixelRound() }
    var cgf: CGFloat { return CGFloat(self) }
    var i: Int { return Int(self) }
}

// MARK: - CGFloat

extension CGFloat {

    func roundToNearestFractionValue(roundWith value: CGFloat) -> CGFloat {
        let remainder = self.truncatingRemainder(dividingBy: value)
        let shouldRoundUp = remainder >= value/2 ? true : false
        let multiple = floor(self / value)
        let returnValue = !shouldRoundUp ? value * multiple : value * multiple + value
        return returnValue
    }

    func pixelRound() -> CGFloat {
        switch UIScreen.main.scale {
        case 3:
            let truncatingRemainder = self.truncatingRemainder(dividingBy: 1)
            switch truncatingRemainder {
            case 0..<0.1666666667:
                return floor(self)
            case 0.1666666667..<0.5:
                return floor(self) + 0.33
            case 0.5..<0.8333333333:
                return floor(self) + 0.67
            default:
                return floor(self) + 1
            }
        default:
            let value: CGFloat = UIScreen.main.scale == 1 ? 1 : 0.5
            let remainder = self.truncatingRemainder(dividingBy: value)
            let shouldRoundUp = remainder >= (value / 2) ? true : false
            let multiple = floor(self / value)
            return !shouldRoundUp ? value * multiple : value * multiple + value
        }
    }

    var f: Float {return Float(self)}
    var d: Double { return Double(self) }
    var i: Int { return Int(self) }
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
    var clasp: CGFloat { return self.adjustToScreenSize().pixelRound() }

}

// MARK: - Foundation.Notification

extension Foundation.Notification {

    var animationDuration: Double {
        if let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            duration > 0 {
            return duration
        }
        return 0.25
    }

    var animationOptions: UIViewAnimationOptions {
        if let rawCurve = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            return UIViewAnimationOptions(rawValue: rawCurve << 16)
        }
        return []
    }

    var animationCurve: UIViewAnimationCurve {
        if let rawCurve = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIViewAnimationCurve(rawValue: rawCurve) {
            return curve
        }
        return .easeInOut
    }

    var keyboardEndFrame: CGRect {
        if let nsValue = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return nsValue.cgRectValue
        }
        return .zero
    }

}

// MARK: NSAttributedString

extension NSAttributedString {
    /**
     Will return an attributed string.

     - parameter text: String for text
     - parameter font: Font. defaults to system font 14pt
     - parameter color: Text color defaults to vimvest black
     - parameter lineSpacing: Spacing for lines. Play with this and lineHeightMultiple
     - parameter lineHeightMultiple: Play with this and lineSpacing if needed (optional)
     - parameter alignement: Align text in box
     - parameter shadow: Shadow for attributed string
     */
    static func string(with text: String,
                       font: UIFont = .systemFont(ofSize: 14),
                       color: UIColor,
                       kern: CGFloat? = nil,
                       lineSpacing: CGFloat? = nil,
                       lineHeightMultiple: CGFloat? = nil,
                       alignement: NSTextAlignment? = nil,
                       shadow: NSShadow? = nil) -> NSAttributedString {
        var attributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: color,
            .font: font
        ]
        if let kern = kern {
            attributes[.kern] = kern
        }
        let paragraphStyle = NSMutableParagraphStyle()
        if let spacing = lineSpacing {
            paragraphStyle.lineHeightMultiple = lineHeightMultiple ?? 1
            paragraphStyle.lineSpacing = spacing
        }
        if let align = alignement {
            paragraphStyle.alignment = align
        }
        attributes[.paragraphStyle] = paragraphStyle
        if let shadow = shadow {
            attributes[.shadow] = shadow
        }
        let titleAttributedString = NSAttributedString(string: text, attributes: attributes)
        return titleAttributedString
    }

    convenience init(_ text: String, font: UIFont, color: UIColor) {
        self.init(string: text, attributes: [
            .foregroundColor: color,
            .font: font
            ])
    }

}
