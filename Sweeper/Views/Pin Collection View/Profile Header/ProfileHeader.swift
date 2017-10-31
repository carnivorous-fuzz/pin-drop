//
//  ProfileHeader
//  Sweeper
//
//  Created by Paul Sokolik on 10/29/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import Mapbox

@objc protocol ProfileHeaderDelegate: class {
    @objc optional func profileHeaderSettingsTouched(_ profileHeader: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var visitsLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    var delegate: ProfileHeaderDelegate?
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
            self.mapView.showAnnotations(annotations, animated: true)
            postsLabel.text = "\(pins.count)"
        }
    }
    var user: User! {
        didSet {
            if let imageUrl = user.getImageUrl() {
                profileImageView.setImageWith(imageUrl)
            } else {
                profileImageView.image = UIImage(named: "default_profile")
            }
            
            if user != User.currentUser {
                settingsButton.isHidden = true
            } else {
                settingsButton.isHidden = false
            }
            
            usernameLabel.text = user.getFullName()
            visitsLabel.text = "0"
            PinService.sharedInstance.visitedPinCount(user) { (count) in
                self.visitsLabel.text = "\(count)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // image view setup
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        
        // map setup
        mapView = MGLMapView(frame: mapContainerView.bounds, styleURL: MGLStyle.streetsStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = false
        mapView.delegate = self
        mapContainerView.addSubview(mapView)
        
        //button styling
        settingsButton.backgroundColor = .white
        settingsButton.layer.cornerRadius = 3
        settingsButton.layer.borderWidth = 1
        settingsButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        settingsButton.layer.borderColor = UIConstants.Theme.lightGray.cgColor
    }
    
    @IBAction func onTouchSettings(_ sender: Any) {
        delegate?.profileHeaderSettingsTouched!(self)
    }
    
}

// MARK: Mapbox map view delegate
extension ProfileHeader: MGLMapViewDelegate {
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
            print("TODO! Segue to details!", pinAnnotation.pin.locationName ?? "No Name")
        }
    }
}

