//
//  FadeTransition.swift
//  Pindrop
//
//  Created by Wuming Xie on 10/30/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class FadeTransition: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var swipeRight = true
    fileprivate var usingGesture = false
    fileprivate var animationDuration = 0.05
}

extension FadeTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.view(forKey: .from), let toVC = transitionContext.view(forKey: .to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC, belowSubview: fromVC)
        
        toVC.alpha = 0.0
        UIView.animate(withDuration: animationDuration, animations: {
            toVC.alpha = 1.0
            fromVC.alpha = 0.0
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled && finished)
        }
    }
}
