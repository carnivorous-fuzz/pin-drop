//
//  PinViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import GoogleMaps

class PinViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var marker: GMSMarker!

    override func viewDidLoad() {
        super.viewDidLoad()

        messageLabel.text = marker.title
    }

}
