//
//  UIImage+ImageEffects.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity function_body_length

import UIKit
import Accelerate

public extension UIImage {

    func resize(to: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = to.width  / size.width
        let heightRatio = to.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.width * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }

    func resize(targetSize: CGSize, cornerRadius: CGFloat? = nil, corners: UIRectCorner = .allCorners) -> UIImage {
        var scaledImageRect = CGRect.zero

        let aspectWidth: CGFloat = targetSize.width / self.size.width
        let aspectHeight: CGFloat = targetSize.height / self.size.height
        let aspectRatio: CGFloat = max(aspectWidth, aspectHeight)

        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (targetSize.width - scaledImageRect.size.width) / 2
        scaledImageRect.origin.y = (targetSize.height - scaledImageRect.size.height) / 2

        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)

        if let cornerRadius = cornerRadius {
            UIBezierPath(
                roundedRect: CGRect(origin: .zero, size: targetSize),
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            ).addClip()
        }
        self.draw(in: scaledImageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func convertImageToBlackAndWhite() -> UIImage {
        let rect = CGRect(origin: .zero, size: self.size)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        guard let context = CGContext(
            data: nil,
            width: Int(rect.width),
            height: Int(rect.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue),
            let cgImage = self.cgImage else {
                return self
        }
        context.draw(cgImage, in: rect)
        guard let imageRef = context.makeImage() else { return self }
        return UIImage(cgImage: imageRef)
    }

    public func applyLightEffect() -> UIImage? {
        return applyBlur(at: 30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
    }

    public func applyExtraLightEffect() -> UIImage? {
        return applyBlur(at: 20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
    }

    public func applyDarkEffect() -> UIImage? {
        return applyBlur(at: 20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
    }

    public func applyTintEffectWithColor(_ tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor

        let componentCount = tintColor.cgColor.numberOfComponents

        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0

            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }

        return applyBlur(at: 10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }

    public func applyBlur(at blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        // Check pre-conditions.
        guard size.width >= 1, size.height >= 1 else {
            print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
            return nil
        }
        guard let cgImage = self.cgImage else {
            print("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        guard maskImage == nil || maskImage!.cgImage != nil else {
            print("*** error: maskImage must be backed by a CGImage: \(String(describing: maskImage))")
            return nil
        }

        let fltEpsilon: CGFloat = Float.ulpOfOne.cgf
        let imageRect: CGRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage: UIImage = self

        let hasBlur: Bool = blurRadius > fltEpsilon
        let hasSaturationChange: Bool = fabs(saturationDeltaFactor - 1.0) > fltEpsilon

        if hasBlur || hasSaturationChange {

            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            guard let effectInContext = UIGraphicsGetCurrentContext() else { return  nil }

            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -size.height)
            effectInContext.draw(cgImage, in: imageRect)

            var effectInBuffer = createEffectBuffer(effectInContext)

            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

            guard let effectOutContext = UIGraphicsGetCurrentContext() else { return  nil }
            var effectOutBuffer = createEffectBuffer(effectOutContext)

            if hasBlur {
                setBlurOnImage(
                    at: blurRadius,
                    effectInBuffer: &effectInBuffer,
                    effectOutBuffer: &effectOutBuffer
                )
            }
            if hasSaturationChange {
                setSaturationOnImage(
                    saturationDeltaFactor: saturationDeltaFactor,
                    hasBlur: hasBlur,
                    effectInBuffer: &effectInBuffer,
                    effectOutBuffer: &effectOutBuffer
                )
            }
            let effectImageBuffersAreSwapped = hasSaturationChange && hasBlur
            if !effectImageBuffersAreSwapped { effectImage = UIGraphicsGetImageFromCurrentImageContext()! }
            UIGraphicsEndImageContext()
            if effectImageBuffersAreSwapped { effectImage = UIGraphicsGetImageFromCurrentImageContext()! }
            UIGraphicsEndImageContext()
        }

        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        guard let outputContext = UIGraphicsGetCurrentContext() else { return nil }

        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -size.height)

        // Draw base image.
        outputContext.draw(cgImage, in: imageRect)

        // Draw effect image.
        if hasBlur {
            outputContext.saveGState()
            if let maskCGImage = maskImage?.cgImage {
                outputContext.clip(to: imageRect, mask: maskCGImage)
            }
            outputContext.draw(effectImage.cgImage!, in: imageRect)
            outputContext.restoreGState()
        }

        // Add in color tint.
        if let color = tintColor {
            outputContext.saveGState()
            outputContext.setFillColor(color.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }

        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return outputImage
    }

    class func gradientImage(withSize size: CGSize,
                             startColor: UIColor,
                             endColor: UIColor,
                             startLocation: CGFloat = 0,
                             endLocation: CGFloat = 1) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        UIGraphicsPushContext(context)
        let locations: [CGFloat] = [startLocation, endLocation]
        let (r1, g1, b1, a1) = startColor.components
        let (r2, g2, b2, a2) = endColor.components
        let components: [CGFloat] = [r1, g1, b1, a1, r2, g2, b2, a2]
        let rgbColorspace = CGColorSpaceCreateDeviceRGB()
        guard let glossGradient = CGGradient(
            colorSpace: rgbColorspace,
            colorComponents: components,
            locations: locations,
            count: 2
            ) else { return UIImage() }
        let startPoint = CGPoint(x: 0, y: size.height / 2)
        let endPoint = CGPoint(x: size.width, y: size.height / 2)
        context.drawLinearGradient(glossGradient, start: startPoint, end: endPoint, options: [.drawsAfterEndLocation])
        UIGraphicsPopContext()
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

private extension UIImage {

    func setBlurOnImage(at blurRadius: CGFloat, effectInBuffer: UnsafePointer<vImage_Buffer>, effectOutBuffer: UnsafePointer<vImage_Buffer>) {
        // A description of how to compute the box kernel width from the Gaussian
        // radius (aka standard deviation) appears in the SVG spec:
        // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
        //
        // For larger values of 's' (s >= 2.0), an approximation can be used: Three
        // successive box-blurs build a piece-wise quadratic convolution kernel, which
        // approximates the Gaussian kernel to within roughly 3%.
        //
        // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
        //
        // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
        //
        let inputRadius = blurRadius * UIScreen.main.scale
        let squareRootOf2Pi: CGFloat = sqrt(2 * .pi).cgf
        let d: UInt32 = UInt32(floor(inputRadius * 3.0 * squareRootOf2Pi / 4 + 0.5))
        // force radius to be odd so that the three box-blur methodology works.
        let radius = (d % 2 != 1) ? (d + 1) : d
        let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
        vImageBoxConvolve_ARGB8888(effectInBuffer, effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(effectOutBuffer, effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(effectInBuffer, effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
    }

    func setSaturationOnImage(saturationDeltaFactor: CGFloat, hasBlur: Bool, effectInBuffer: UnsafePointer<vImage_Buffer>, effectOutBuffer: UnsafePointer<vImage_Buffer>) {
        let s: CGFloat = saturationDeltaFactor
        let floatingPointSaturationMatrix: [CGFloat] = [
            0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
            0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
            0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
            0, 0, 0, 1
        ]

        let divisor: CGFloat = 256
        let matrixSize = floatingPointSaturationMatrix.count
        var saturationMatrix = [Int16](repeating: 0, count: matrixSize)

        for i: Int in 0 ..< matrixSize {
            saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
        }

        if hasBlur {
            vImageMatrixMultiply_ARGB8888(effectOutBuffer, effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
        } else {
            vImageMatrixMultiply_ARGB8888(effectInBuffer, effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
        }
    }

    func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
        let data = context.data
        let width = vImagePixelCount(context.width)
        let height = vImagePixelCount(context.height)
        let rowBytes = context.bytesPerRow
        return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
    }

}
