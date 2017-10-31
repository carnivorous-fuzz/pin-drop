//
//  FullScreenImageViewController.swift
//  Sweeper
//
//  Created by Raina Wang on 10/29/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    var pinImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenImage = UIImageView(image: pinImage)
        fullScreenImage.frame = UIScreen.main.bounds
        fullScreenImage.backgroundColor = .black
        fullScreenImage.contentMode = .scaleAspectFit
        fullScreenImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(scaleImage))
        fullScreenImage.addGestureRecognizer(tap)
        fullScreenImage.addGestureRecognizer(pinch)
        
        view.addSubview(fullScreenImage)
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc fileprivate func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func scaleImage(sender: UIPinchGestureRecognizer) {
        if let view = sender.view {
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
            })
        }
    }
}
