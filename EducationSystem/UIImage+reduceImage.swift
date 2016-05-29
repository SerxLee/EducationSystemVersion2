//
//  UIImage+reduceImage.swift
//  EducationSystem
//
//  Created by Serx on 16/5/29.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation
import UIKit

/** reduceImage Extends UIImage

*/
extension UIImage {
    
    func imageByScalingAndCroppingForSize(targetSize: CGSize) -> UIImage {
        let sourceImage = self
        let newImage: UIImage?
        
        let imageSize: CGSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        
        var scaleFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = targetWidth
        var scaledHeight: CGFloat = targetHeight
        var thumbnailPoint: CGPoint = CGPointMake(0.0,0.0)
        
        if CGSizeEqualToSize(imageSize, targetSize) == false {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat = targetHeight / height
            
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            }
            else {
                scaleFactor = heightFactor
            }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }
            else if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
        UIGraphicsBeginImageContext(targetSize)
        // 目标尺寸
        var thumbnailRect: CGRect = CGRectZero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.drawInRect(thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if newImage == nil {
            NSLog("could not scale image")
        }
        UIGraphicsEndImageContext()
        return newImage!
    }
}
