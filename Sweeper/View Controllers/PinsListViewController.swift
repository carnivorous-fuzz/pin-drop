//
//  PinsListViewController.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

class PinsListViewController: UIViewController, UITableViewDataSource, NVActivityIndicatorViewable {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var pins: [Pin]!
    fileprivate var currentLocation: CLLocation?
    fileprivate var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimating()

        tableView.register(UINib(nibName: "PinCell", bundle: nil), forCellReuseIdentifier: "PinCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        getLocation()
        loadPins()
    }
    
    @objc fileprivate func loadPins() {
        PinService.sharedInstance.fetchPins { (pins: [Pin]?, error: Error?) in
            if let pins = pins {
                self.pins = pins
                self.tableView.reloadData()
                self.stopAnimating()
            } else {
                let button = Dialog.button(title: "Try Again", type: .plain, action: nil)
                Dialog.show(controller: self, title: "Unable to load pins", message: error?.localizedDescription ?? "Error", buttons: [button], image: nil, dismissAfter: nil, completion: nil)
            }
        }
    }
    
    @objc fileprivate func onRefresh(_ control: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.loadPins()
            control.endRefreshing()
        }
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
        let detailsVC = UIStoryboard.pinDetailsVC
        detailsVC.pin = pins[indexPath.row]
        show(detailsVC, sender: nil)
    }
}
