//
//  PinCalloutView.swift
//  Pindrop
//
//  Created by Paul Sokolik on 10/25/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import Mapbox

class PinCalloutView: UIView, MGLCalloutView {
    var representedObject: MGLAnnotation
    
    // Allow the callout to remain open during panning.
    let dismissesAutomatically: Bool = false
    let isAnchoredToAnnotation: Bool = true
    
    // https://github.com/mapbox/mapbox-gl-native/issues/9228
    override var center: CGPoint {
        set {
            var newCenter = newValue
            newCenter.y = newCenter.y - bounds.midY
            super.center = newCenter
        }
        get {
            return super.center
        }
    }
    
    lazy var leftAccessoryView = UIView() /* unused */
    lazy var rightAccessoryView = UIView() /* unused */
    
    weak var delegate: MGLCalloutViewDelegate?
    
    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0
    
    let customPinCalloutView: CustomPinCalloutView!
    let mainBody: UIView!
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        customPinCalloutView = CustomPinCalloutView(frame: .zero)
        if let pinAnnotation = representedObject as? PinAnnotation {
            customPinCalloutView.pin = pinAnnotation.pin
            mainBody = customPinCalloutView.contentView
            
            // Resize here otherwise mapview does some crazy magic
            let size = mainBody.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            mainBody.frame.size.width = size.width
            mainBody.frame.size.height = size.height
        } else {
            self.mainBody = UIView()
        }
        
        super.init(frame: mainBody.frame)
        
        backgroundColor = .clear
        
        mainBody.backgroundColor = .white
        mainBody.layer.cornerRadius = 4.0
        
        addSubview(mainBody)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MGLCalloutView API
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        if !representedObject.responds(to: #selector(getter: MGLAnnotation.title)) {
            return
        }
        
        // Prepare title label
        if isCalloutTappable() {
            // Handle taps and eventually try to send them to the delegate (usually the map view)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PinCalloutView.calloutTapped))
            mainBody.addGestureRecognizer(tapRecognizer)
        } else {
            // Disable tapping and highlighting
            mainBody.isUserInteractionEnabled = false
        }
        
        // Prepare our frame, adding extra space at the bottom for the tip
        let frameWidth = mainBody.bounds.size.width
        let frameHeight = mainBody.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        view.addSubview(self)
        
        if animated {
            alpha = 0

            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }
    
    // MARK: - Callout interaction handlers
    func isCalloutTappable() -> Bool {
        if let delegate = delegate {
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }
    
    @objc func calloutTapped() {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }
    
    // MARK: - Custom tooltip styling
    override func draw(_ rect: CGRect) {
        // Draw the pointed tip at the bottom
        let fillColor : UIColor = .white
        
        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight - 1
        
        let currentContext = UIGraphicsGetCurrentContext()!
        
        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
        tipPath.closeSubpath()
        
        fillColor.setFill()
        currentContext.addPath(tipPath)
        currentContext.fillPath()
    }
}

