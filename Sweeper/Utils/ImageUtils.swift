//
//  ImageUtils.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/15/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import AFNetworking

class ImageUtils {
    
    class func loadImage(forView view: UIImageView, defaultImage: UIImage?, url: URL) {
        view.setImageWith(
            URLRequest(url: url),
            placeholderImage: nil,
            success: { (request, response, image) in
                view.image = image
                
                if response != nil {
                    // Fade in image if it's from network
                    view.alpha = 0.0
                    UIView.animate(withDuration: 0.5, animations: {
                        view.alpha = 1.0
                    })
                }
        }) { (request, response, error) in
            print(error.localizedDescription)
            view.image = defaultImage
        }
    }
}

extension UIImage {
    func compress(maxWidth: CGFloat = 600, maxHeight: CGFloat = 400) -> UIImage {
        let compressionQuality = CGFloat(0.4)
        var imgRatio = size.width / size.height
        let maxRatio = maxWidth / maxHeight
        
        var compressedHeight = size.height
        var compressedWidth = size.width
        if size.width > maxWidth || size.height > maxHeight {
            if imgRatio < maxRatio {
                imgRatio = maxHeight / size.height
                compressedWidth = imgRatio * size.width
                compressedHeight = maxHeight
            } else if imgRatio > maxRatio {
                imgRatio = maxWidth / size.width
                compressedHeight = imgRatio * size.height
                compressedWidth = maxWidth
            } else {
                compressedHeight = maxHeight
                compressedWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0, y: 0, width: compressedWidth, height: compressedHeight)
        UIGraphicsBeginImageContext(rect.size)
        draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext();
        return UIImage(data: imageData)!
    }
}
