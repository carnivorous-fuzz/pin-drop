//
//  PinsMapViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import Mapbox
import Parse

class PinsMapViewController: UIViewController {
    
    let user = User.currentUser
    let defaultLocation = CLLocation(latitude: 37.787353, longitude: -122.421561)
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: MGLMapView!
    var zoomLevel = 15.0
    var pins: [Pin] = []
    var annotations: [PinAnnotation] = []
    var userLocationButton: UserLocationButton!

    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Request location
        requestLocationPermission()

        // Create map
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(defaultLocation.coordinate, zoomLevel: zoomLevel, animated: false)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isHidden = true
        view.addSubview(mapView)
        setupLocationButton()
        registerForNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // refilter on every load in case pins were visited on the details page
        pins = pins.filter { (pin: Pin) -> Bool in
            let visited = pin.visited ?? false
            if visited {
                let idx = self.annotations.index(where: { (annotation: PinAnnotation) -> Bool in
                    return annotation.pin == pin
                })
                
                if let idx = idx {
                    mapView.removeAnnotation(annotations[idx])
                    annotations.remove(at: idx)
                }
                
            }
            return !visited
        }
    }
    
    // MARK: Action handlers
    @objc fileprivate func loadPins() {
        if let currentLocation = user?.currentLocation {
            PinService.sharedInstance.fetchPins(for: user!, visited: false, near: currentLocation) {  (pins, error) in
                if let pins = pins {
                    pins.forEach({ (pin) in
                        if !self.pins.contains(pin) {
                            self.pins.append(pin)
                            if pin.location != nil {
                                let point = PinAnnotation(fromPin: pin)
                                self.annotations.append(point)
                            }
                        }
                    })
                    self.mapView.addAnnotations(self.annotations)
                } else {
                    print(error.debugDescription)
                }
            }
        }
    }
    
    @IBAction func locationButtonTapped() {
        var mode: MGLUserTrackingMode
        
        switch (mapView.userTrackingMode) {
        case .none:
            mode = .follow
            break
        case .follow:
            mode = .followWithHeading
            break
        case .followWithHeading:
            mode = .followWithCourse
            break
        case .followWithCourse:
            mode = .none
            break
        }
        
        mapView.userTrackingMode = mode
    }
    
    @objc private func pinLiveQueryHandler(_ notification: Notification) {
        if let createdPin = Pin.getPinFromNotification(notification) {
            if createdPin.location != nil {
                let createdPoint = PinAnnotation(fromPin: createdPin)
                pins.append(createdPin)
                annotations.append(createdPoint)
                mapView.addAnnotation(createdPoint)
            }
        }
    }
    
    // MARK: Helpers
    private func requestLocationPermission() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func setupLocationButton() {
        userLocationButton = UserLocationButton()
        userLocationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        userLocationButton.tintColor = UIConstants.Theme.green
        view.addSubview(userLocationButton)

        // Do some basic auto layout.
        userLocationButton.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            userLocationButton.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 10),
            userLocationButton.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            userLocationButton.heightAnchor.constraint(equalToConstant: userLocationButton.frame.size.height),
            userLocationButton.widthAnchor.constraint(equalToConstant: userLocationButton.frame.size.width)
        ]

        view.addConstraints(constraints)
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pinLiveQueryHandler),
                                               name: Pin.pinLiveQueryNotification,
                                               object: nil)
    }
}

// MARK:- Location manager delegate
extension PinsMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            user?.setCurrentLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            loadPins()
            mapView?.setCenter(location.coordinate, zoomLevel: mapView?.zoomLevel ?? zoomLevel, animated: !mapView.isHidden)
            if mapView.isHidden {
                mapView.isHidden = false
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

// MARK:- Mapbox map view delegate
extension PinsMapViewController: MGLMapViewDelegate {
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

    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
        userLocationButton.updateArrow(for: mode)
    }
}
