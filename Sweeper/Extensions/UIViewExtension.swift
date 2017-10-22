//
//  UIViewExtension.swift
//  Sweeper
//
//  Created by Raina Wang on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

extension UIView {
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius

        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func circleBorder() {
        self.layer.borderColor = UIConstants.Theme.turquose.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    func slightlyRoundBorder() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIConstants.Theme.turquose.cgColor
        self.layer.masksToBounds = true
    }
}
