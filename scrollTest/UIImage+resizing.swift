//
//  UIImage+resizing.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/7/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit

extension UIImage {
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height

        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
    
    
    
//    /// Returns a image that fills in newSize
//    func resizedImage(newSize: CGSize) -> UIImage {
//        // Guard newSize is different
//        guard self.size != newSize else { return self }
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
//        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return newImage
//    }
//
//
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageAspectFixedHeight(maxHeight: Int) -> UIImage {
        let widthFactor = size.width / size.height
        //let heightFactor = size.height / rectSize.height
        let height = CGFloat(maxHeight)
        let newSize = CGSize(width: height * widthFactor, height: height)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
}
