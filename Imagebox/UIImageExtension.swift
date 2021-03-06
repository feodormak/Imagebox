//
//  UIImageExtension.swift
//  Imagebox
//
//  Created by feodor on 16/10/17.
//  Copyright © 2017 feodor. All rights reserved.
//
// Code below is by samewize @ http://samwize.com/2016/06/01/resize-uiimage-in-swift/

import UIKit

extension UIImage {
    
    // Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // Returns a resized image that fits in rectSize, keeping it's aspect ratio
    // Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width:size.width/resizeFactor, height:size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
}
