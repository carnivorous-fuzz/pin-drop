//
//  PinsListViewController.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import CoreLocation

class PinsListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var pins: [Pin]!
    fileprivate var currentLocation: CLLocation?
    fileprivate var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        getLocation()
        PinService.sharedInstance.fetchPins { (pins: [Pin]?, error: Error?) in
            if let pins = pins {
                self.pins = pins
                self.tableView.reloadData()
            } else {
                print(error.debugDescription)
            }
        }
        
    }
    
    private func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Action handlers
    @IBAction func onChangeViewType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "PinsMapViewNavigationController")
            UIView.beginAnimations("animation", context: nil)
            UIView.setAnimationDuration(1.0)
            navigationController!.pushViewController(vc!, animated: false)
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
            UIView.commitAnimations()
        }
    }

}

// MARK: Location manager delegate
extension PinsListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            self.tableView.reloadData()
        }
    }
}

// MARK: Table view delegate
extension PinsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinCell", for: indexPath) as? PinCell
        cell?.pin = pins[indexPath.row]
        cell?.currentLocation = currentLocation
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
