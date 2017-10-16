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
