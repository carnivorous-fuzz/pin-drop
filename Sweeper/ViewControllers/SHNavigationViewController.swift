//
//  SHNavigationViewController.swift
//  Sweeper
//
//  Created by Raina Wang on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import MapboxDirections
import MapboxNavigation

class SHNavigationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var scavengerHunt: ScavengerHunt!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
//        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047), name: "Mapbox")
//        let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), name: "White House")
//        startNav(from: origin, to: destination)
    }

    fileprivate func startNav(from: Waypoint, to: Waypoint) {
        let options = RouteOptions(waypoints: [from, to])
        options.routeShapeResolution = .full
        options.includesSteps = true
        options.profileIdentifier = MBDirectionsProfileIdentifier.walking

        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first else { return }

            let viewController = NavigationViewController(for: route)
            //            self.present(viewController, animated: true, completion: nil)
            self.view.addSubview(viewController.view)
        }
    }
}

extension SHNavigationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PinOverviewCell") as? PinOverviewCell {
            if self.scavengerHunt.pins != nil {
                cell.rowNumberLabel.text = "\(indexPath.row + 1)"
                cell.pin = self.scavengerHunt.pins![indexPath.row]
                return cell
            }
        }
        return PinOverviewCell()
    }
}
