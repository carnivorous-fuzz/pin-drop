//
//  UserLocationButton.swift
//  Pindrop
//
//  Created by Raina Wang on 10/24/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import Mapbox

class UserLocationButton : UIButton {
    private let size: CGFloat = 40
    private var arrow: CAShapeLayer?

    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        layer.cornerRadius = 4

        layoutArrow()
    }

    private func layoutArrow() {
        if arrow == nil {
            let arrow = CAShapeLayer()
            arrow.path = arrowPath()
            arrow.bounds = CGRect(x: 0, y: 0, width: size / 2, height: size / 2)
            arrow.position = CGPoint(x: size / 2, y: size / 2)
            arrow.shouldRasterize = true
            arrow.rasterizationScale = UIScreen.main.scale
            arrow.drawsAsynchronously = true

            self.arrow = arrow
            updateArrow(for: .none)
            layer.addSublayer(self.arrow!)
        }
    }

    private func arrowPath() -> CGPath {
        let max: CGFloat = size / 2

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: max * 0.5, y: 0))
        bezierPath.addLine(to: CGPoint(x: max * 0.1, y: max))
        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: max * 0.65))
        bezierPath.addLine(to: CGPoint(x: max * 0.9, y: max))
        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: 0))
        bezierPath.close()

        return bezierPath.cgPath
    }

    func updateArrow(for mode: MGLUserTrackingMode) {
        var stroke: CGColor
        switch (mode) {
        case .none:
            stroke = UIColor.white.cgColor
        case .follow:
            stroke = tintColor.cgColor
        case .followWithHeading, .followWithCourse:
            stroke = UIColor.clear.cgColor
        }
        arrow!.strokeColor = stroke

        // Re-center the arrow, based on its current orientation.
        arrow!.position = (mode == .none || mode == .followWithCourse) ? CGPoint(x: size / 2, y: size / 2) : CGPoint(x: size / 2 + 2, y: size / 2 - 2)

        arrow!.fillColor = (mode == .none || mode == .follow) ? UIColor.clear.cgColor : tintColor.cgColor

        let rotation: CGFloat = (mode == .follow || mode == .followWithHeading) ? 0.66 : 0
        arrow!.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))

        layoutIfNeeded()
    }
}
