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
    @IBOutlet weak var actionsView: PinActionsView!
    @IBOutlet weak var clockImageView: UIImageView!
    
    let pinService = PinService.sharedInstance
    var currentLocation: CLLocation?
    var pinLocation: CLLocation?
    var likesCount = 0
    var pinLike: PinLike?
    var pin: Pin! {
        didSet {
            if let imageUrl = pin.getImageUrl() {
                ImageUtils.loadImage(forView: pinImageView, defaultImage: #imageLiteral(resourceName: "cancel"), url: imageUrl)
            } else {
                pinImageView.image = #imageLiteral(resourceName: "cancel")
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
            
            // Set like state and count
            actionsView.delegate = self
            pinService.likesOnPin(pin) { (count) in
                self.likesCount = count
                self.actionsView.updateLikesCount(animated: false, count: count)
            }
            
            pinService.likedPin(pin) { (pinLike) in
                self.pinLike = pinLike
                if let _ = pinLike {
                    self.actionsView.updateLikeIcon(animated: false, liked: true)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Disable selection
        selectionStyle = .none
        
        // Change image radius
        pinImageView.layer.cornerRadius = 12
        pinImageView.clipsToBounds  = true

        // Custom looks/behaviors
        usernameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onNameTap)))
        actionsView.commentView.isHidden = true
        
        clockImageView.tintColor = UIColor.gray
    }
    
    override func prepareForReuse() {
        actionsView.reset()
    }

    @objc private func onNameTap(_ sender: UITapGestureRecognizer) {
        print("Put segue here")
    }
}

extension PinCell: PinActionsViewDelegate {
    func pinActionsDidLike(_ pinActionsView: PinActionsView) {
        var likeChangedTo = false
        if let pinLike = pinLike {
            pinLike.deleteInBackground(block: { (result, error) in
                if result {
                    self.pinLike = nil
                }
            })
        } else {
            pinLike = PinLike()
            pinLike?.user = User.currentUser
            pinLike?.likedPin = pin
            pinLike?.saveInBackground()
            likeChangedTo = true
        }
        actionsView.updateLikeIcon(animated: true, liked: likeChangedTo)
    }
    
    func pinActionsDidComment(_ pinActionsView: PinActionsView) {
        // Do nothing
    }
}
