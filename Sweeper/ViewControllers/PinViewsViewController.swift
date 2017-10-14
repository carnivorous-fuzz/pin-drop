//
//  PinViewsViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class PinViewsViewController: UIViewController {
    
    let defaultLocation = CLLocation(latitude: 37.7749, longitude: 122.4194)
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel = Float(15.0)
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?

    override func viewDidLoad() {
        super.viewDidLoad()

        requestLocationPermission()
        
        // Create a map.
        placesClient = GMSPlacesClient.shared()
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        if let styleUrl = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
            do {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleUrl)
            } catch {
                NSLog("Failed to load map style")
            }
        }
        
        view.addSubview(mapView)
        mapView.isHidden = true
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

// MARK:- Location manager delegate
extension PinViewsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
        }
    }
    
    // TODO: Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
}
