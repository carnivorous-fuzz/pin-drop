//
//  KeyboardNotifications.swift
//  PinDrop
//
//  Created by Wuming Xie on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

private extension UIViewAnimationOptions {
    init(curve: Int) {
        guard let curve = UIViewAnimationCurve(rawValue: curve) else {
            self = .curveEaseInOut
            return
        }
        
        switch curve {
        case .easeIn:
            self = .curveEaseIn
        case .easeInOut:
            self = .curveEaseInOut
        case .easeOut:
            self = .curveEaseOut
        case .linear:
            self = .curveLinear
        }
    }
}

struct KeyboardNotification {
    
    let notification: Notification
    let userInfo: [AnyHashable: Any]
    
    init(_ notification: Notification) {
        self.notification = notification
        if let userInfo = notification.userInfo {
            self.userInfo = userInfo
        } else {
            self.userInfo = [:]
        }
    }
    
    var animationDuration: TimeInterval {
        guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return 0.25
        }
        
        return animationDuration.doubleValue
    }
    
    var animationCurve: UIViewAnimationOptions {
        guard let number = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return .curveEaseInOut
        }
        
        return UIViewAnimationOptions(curve: number.intValue)
    }
    
    var frameEnd: CGRect {
        guard let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return CGRect.zero
        }
        
        return value.cgRectValue
    }
}
