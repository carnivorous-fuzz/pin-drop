//
//  PinCell.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import CoreLocation

class PinCell: UITableViewCell {

    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
//    @IBOutlet weak var likeCountLabel: UILabel!
//    @IBOutlet weak var commentCountLabel: UILabel!
    
    var currentLocation: CLLocation?
    var pinLocation: CLLocation?
    var pin: Pin! {
        didSet {
            if let imageUrl = pin.getImageUrl() {
                pinImageView.setImageWith(imageUrl)
            }
            
            if let lat = pin.location?.latitude,
               let lng = pin.location?.longitude {
                pinLocation = CLLocation(latitude: lat, longitude: lng)
                Location.getAddress(from: pinLocation!, success: { (address: String) in
                    self.titleLabel.text = address
                }) { (error: Error) in
                    print("couldn't get address string")
                }
            }
            
            if let loc1 = currentLocation,
               let loc2 = pinLocation {
                distanceLabel.text = Location.getPrettyDistance(loc1: loc1, loc2: loc2)
            }
            
            usernameLabel.text = pin.creator?.getFullName() ?? "anon user"
            if let createdAt = pin.createdAt {
                timestampLabel.text = TimeUtils.getPrettyTimeAgoString(createdAt)
            }
            
            blurbLabel.text = pin.blurb
//            likeCountLabel.text = "16"
//            commentCountLabel.text = "5"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pinImageView.layer.cornerRadius = 7 //pinImageView.frame.size.width / 2
        pinImageView.clipsToBounds  = true
    }

}
