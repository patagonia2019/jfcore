//
//  UIImage+JFCore.swift
//  Pods
//
//  Created by Javier Fuchs on 9/26/16.
//
//

import Foundation

extension UIImage {

    public func resizeImageWithSize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    public func patternColor(customSize: CGSize) -> UIColor
    {
        var size = customSize
        let hw = max(size.width, size.height)
        size.width = hw
        size.height = hw
        let gray = self.convertToGrayScale()
        if let bg = gray.resizeImageWithSize(size) {
            let pattern = UIColor.init(patternImage: bg)
            return pattern
        }
        return UIColor.blackColor()
    }
    
    public func convertToGrayScale() -> UIImage {
        let image = self
        let imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        let context = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue)
        
        CGContextDrawImage(context!, imageRect, image.CGImage!)
        let imageRef = CGBitmapContextCreateImage(context!)
        let newImage = UIImage(CGImage: imageRef!)
        
        return newImage
    }
    
    public func convertColor(color: UIColor) -> UIImage {
        let image = self
        let rect:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: image.size.width, height: image.size.height))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let c:CGContextRef = UIGraphicsGetCurrentContext()!
        image.drawInRect(rect)
        CGContextSetFillColorWithColor(c, color.CGColor)
        CGContextSetBlendMode(c, .SourceAtop)
        CGContextFillRect(c, rect)
        let result:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}
