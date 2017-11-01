//
//  ViewedPinsViewController.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import Mapbox
import NVActivityIndicatorView

class ViewedPinsViewController: UIViewController, NVActivityIndicatorViewable {

    // MARK: IB outlets
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: controller variables
    var locationManager: CLLocationManager!
    let defaultLocation = CLLocation(latitude: 37.787353, longitude: -122.421561)
    var currentLocation: CLLocation?
    var mapView: MGLMapView!
    var zoomLevel = 15.0
    var pins: [Pin]!
    var user: User!
    var lastVcStackSize: Int!
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    fileprivate var cellsPerRow: CGFloat! = 3
    
    // MARK: lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Request location
        requestLocationPermission()
        
        // collection view setup
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CollectionViewPinCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewPinCell")
        
        // map setup
        mapView = MGLMapView(frame: mapContainerView.bounds, styleURL: MGLStyle.streetsStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(defaultLocation.coordinate, zoomLevel: zoomLevel, animated: false)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isHidden = true
        mapContainerView.addSubview(mapView)
        
        lastVcStackSize = self.navigationController?.viewControllers.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if user == nil {
            user = User.currentUser
        }
        
        let currentCount = self.navigationController?.viewControllers.count
        // don't reload data if we're unwinding from a child
        if currentCount! < lastVcStackSize {
            return
        }
        
        var annotations = [PinAnnotation]()
        startAnimating()
        PinService.sharedInstance.fetchPins(for: user, visited: true, near: user.currentLocation) { (pins: [Pin]?, error: Error?) in
            self.stopAnimating()
            if error == nil {
                self.pins = pins!
                // init collection view
                self.collectionView.reloadData()
                
                // init map view
                self.pins.forEach({ (pin) in
                    if pin.location != nil {
                        let point = PinAnnotation(fromPin: pin)
                        annotations.append(point)
                    }
                })
                self.mapView.addAnnotations(annotations)
                self.mapView.showAnnotations(annotations, animated: true)
            } else {
                let button = Dialog.button(title: "Try Again", type: .plain, action: nil)
                Dialog.show(controller: self, title: "Unable to load pins", message: error?.localizedDescription ?? "Error", buttons: [button], image: nil, dismissAfter: nil, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lastVcStackSize = self.navigationController?.viewControllers.count
    }
    
    // MARK: helpers
    private func requestLocationPermission() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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

