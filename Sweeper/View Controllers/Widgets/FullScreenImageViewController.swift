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
    var transition: FadeTransition?
    fileprivate var fullScreenImage: UIImageView!
    fileprivate var originalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullScreenImage = UIImageView(image: pinImage)
        fullScreenImage.frame = UIScreen.main.bounds
        fullScreenImage.backgroundColor = .black
        fullScreenImage.contentMode = .scaleAspectFit
        fullScreenImage.isUserInteractionEnabled = true
        fullScreenImage.isMultipleTouchEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(scaleImage))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        fullScreenImage.addGestureRecognizer(pinch)
        fullScreenImage.addGestureRecognizer(pan)
        
        view.addSubview(fullScreenImage)
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc fileprivate func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func scaleImage(sender: UIPinchGestureRecognizer) {
        if let scalableView = sender.view {
            switch sender.state {
            case .changed:
                view.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
            case .ended:
                let scale = max(sender.scale, 1.0)
                UIView.animate(withDuration: 0.1) {
                    scalableView.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            default:
                break
            }
        }
    }
    
    @objc fileprivate func didPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            transition?.hasStarted = true
            originalCenter = fullScreenImage.center
        case .changed:
            fullScreenImage.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
            fullScreenImage.transform = CGAffineTransform(rotationAngle: translation.x * 0.003)
        case .cancelled:
            transition?.cancel()
            fullScreenImage.transform = CGAffineTransform.identity
        case .ended:
            if translation.x > 50 || translation.x < -50 || translation.y > 50 || translation.y < -50{
                let velocity = sender.velocity(in: view)
                UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveEaseIn], animations: {
                    let translation = self.velocityToTranslation(velocity)
                    let affineTransform = CGAffineTransform(translationX: translation.x, y: translation.y).rotated(by: translation.x * CGFloat(Float.pi) / self.view.bounds.width)
                    self.fullScreenImage.transform = affineTransform
                    self.fullScreenImage.alpha = 0.0
                }) { finished in
                    self.dismiss(animated: true, completion: nil)
                    self.transition?.finish()
                }
            } else {
                fullScreenImage.center = originalCenter
                fullScreenImage.transform = CGAffineTransform.identity
            }
        default:
            break
        }
    }
    
    fileprivate func velocityToTranslation(_ velocity: CGPoint) -> CGPoint {
        let factor = velocity.x != 0 ? abs(velocity.x) : abs(velocity.y)
        
        return CGPoint(x: velocity.x * 400 / factor , y: velocity.y * 400 / factor)
    }
}
