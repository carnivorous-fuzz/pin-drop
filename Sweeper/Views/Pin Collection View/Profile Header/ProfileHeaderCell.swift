//
//  ProfileHeaderCell.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/29/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import Mapbox

class ProfileHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var visitsLabel: UILabel!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var separatorLabel: UILabel!
    
    var mapView: MGLMapView!
    var zoomLevel = 15.0
    var annotations = [PinAnnotation]()
    var pins: [Pin]! {
        didSet {
            // init map view
            pins.forEach({ (pin) in
                if pin.location != nil {
                    let point = PinAnnotation(fromPin: pin)
                    annotations.append(point)
                }
            })
            self.mapView.addAnnotations(annotations)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("NIBBED!", mapContainerView)
        layoutIfNeeded()
        
        // map setup
        mapView = MGLMapView(frame: mapContainerView.bounds, styleURL: MGLStyle.streetsStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = false
        mapView.delegate = self
        mapContainerView.addSubview(mapView)
    }
    
    @IBAction func onTouchSettings(_ sender: Any) {
        print("touched settings")
    }
    
}

// MARK: Mapbox map view delegate
extension ProfileHeaderCell: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            let pinAnnotation = annotation as? PinAnnotation
            let pin = pinAnnotation?.pin
            annotationView = PinAnnotationView(reuseIdentifier: reuseIdentifier, pin: pin!)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        mapView.setCenter(annotation.coordinate, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        return PinCalloutView(representedObject: annotation)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return annotation is PinAnnotation
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        if let pinAnnotation = annotation as? PinAnnotation {
//            let vc = UIStoryboard.pinDetailsVC
//            vc.pin = pinAnnotation.pin
            print("TODO! Segue to details!")
        }
    }
}

