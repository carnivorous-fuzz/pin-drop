//
//  ProfileViewController.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var separatorLabel: UILabel!
    
    var user: User!
    
    // MARK: lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if user == nil {
            user = User.currentUser
        }
        
        // don't show "edit" button if we're viewing someone else's profile
        if user == User.currentUser {
            editProfileButton.backgroundColor = UIConstants.Theme.green
            editProfileButton.layer.cornerRadius = 7
            editProfileButton.layer.borderWidth = 1
            editProfileButton.layer.borderColor = UIConstants.Theme.lightGray.cgColor
        } else {
            editProfileButton.isHidden = true
        }
        
        if let imageUrl = user.getImageUrl() {
            profileImageView.setImageWith(imageUrl)
        } else {
            profileImageView.image = UIImage(named: "default_profile")
        }
        nameLabel.text = user.getFullName()
        usernameLabel.text = user.username ?? ""
        emailLabel.text = user.email ?? "youremail@you.com"
    }
    
}

// MARK: collection view delegate
extension ViewedPinsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pins?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewPinCell", for: indexPath) as! CollectionViewPinCell
        cell.pin = pins[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = cellsPerRow - 1
        let availableWidth = view.frame.width - paddingSpace
        let cellWidth = availableWidth / cellsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.pinDetailsVC
        vc.pin = pins[indexPath.row]
        show(vc, sender: nil)
    }
    
}

// MARK: Location manager delegate
extension ViewedPinsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            mapView?.setCenter(location.coordinate, zoomLevel: mapView?.zoomLevel ?? zoomLevel, animated: !mapView.isHidden)
            if mapView.isHidden {
                mapView.isHidden = false
            }
        }
    }
}

// MARK: Mapbox map view delegate
extension ViewedPinsViewController: MGLMapViewDelegate {
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
            let vc = UIStoryboard.pinDetailsVC
            vc.pin = pinAnnotation.pin
            show(vc, sender: nil)
        }
    }
}

