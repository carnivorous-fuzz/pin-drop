//
//  PinViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import GoogleMaps

class PinDetailsViewController: UIViewController {
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var locationBanner: LocationBanner!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    
    var marker: GMSMarker!

    override func viewDidLoad() {
        super.viewDidLoad()
//        pinMarker.pin.markAsViewed(User.currentUser)
        locationBanner.prepare(with: marker.getLocation())
        messageLabel.text = marker.snippet
    }
}
