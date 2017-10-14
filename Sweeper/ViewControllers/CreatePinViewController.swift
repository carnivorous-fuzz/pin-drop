//
//  CreatePinViewController.swift
//  Sweeper
//
//  Created by Raina Wang on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import CoreLocation

class CreatePinViewController: UIViewController {
    @IBOutlet weak var locationBanner: LocationBanner!
    @IBOutlet weak var titleField: FancyTextField!

    fileprivate var currentLocation: CLLocation?
    fileprivate var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        titleField.fieldLabel.text = "Title"
    }
    private func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }
}

// MARK: Location manager delegate
extension CreatePinViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            locationBanner.prepare(with: self.currentLocation!)
        }
    }
}
