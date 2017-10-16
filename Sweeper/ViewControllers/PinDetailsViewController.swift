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
    
    var pinMarker: PinMarker!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationBanner.prepare(with: pinMarker.getLocation())
        messageLabel.text = pinMarker.snippet
        
        messageImage.image = nil
        if let imgURL = URL(string: pinMarker.pin.imageUrlStr ?? "") {
            ImageUtils.loadImage(forView: messageImage, defaultImage: nil, url: imgURL)
        }
    }

}
