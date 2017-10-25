//
//  ViewedPinsViewController.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import Mapbox

class ViewedPinsViewController: UIViewController {

    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var locationManager: CLLocationManager!
    let defaultLocation = CLLocation(latitude: 37.787353, longitude: -122.421561)
    var currentLocation: CLLocation?
    var mapView: MGLMapView!
    var zoomLevel = 15.0
    var columns: Int! = 3
    var pins: [Pin]!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request location
        requestLocationPermission()
        
        // collection view setup
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // map setup
        mapView = MGLMapView(frame: mapContainerView.bounds, styleURL: MGLStyle.darkStyleURL(withVersion: 9))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(defaultLocation.coordinate, zoomLevel: zoomLevel, animated: false)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isHidden = true
        mapContainerView.addSubview(mapView)
        
        if user == nil {
            user = User.currentUser
        }
        
        // TODO: make this fetchArchivedPins once done testing
        var annotations = [PinAnnotation]()
        PinService.sharedInstance.fetchPins { (pins: [Pin]?, error: Error?) in
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
                
            }
        }
    }
    
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
extension ViewedPinsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pins?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewedPinCell", for: indexPath) as! ViewedPinCell
        cell.pin = pins[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
                            + flowLayout.sectionInset.right
                            + (flowLayout.minimumInteritemSpacing * CGFloat(columns - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(columns))
        return CGSize(width: size, height: size)
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
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return annotation is PinAnnotation
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let vc = UIStoryboard.pinDetailsVC
        vc.pinAnnotation = annotation as! PinAnnotation
        show(vc, sender: nil)
    }
}

