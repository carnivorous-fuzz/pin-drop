//
//  PinViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class PinDetailsViewController: UIViewController {
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var locationBanner: LocationBanner!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    
    var pinAnnotation: PinAnnotation!

    override func viewDidLoad() {
        super.viewDidLoad()

//         pinMarker.pin.markAsViewed(User.currentUser)
        locationBanner.prepare(with: pinAnnotation.location)
        messageLabel.text = pinAnnotation.subtitle
        
        messageImage.image = nil
        if let imgURL = URL(string: pinAnnotation.pin.imageUrlStr ?? "") {
            ImageUtils.loadImage(forView: messageImage, defaultImage: nil, url: imgURL)
        }
    }
}
