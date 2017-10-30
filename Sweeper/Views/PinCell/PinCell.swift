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
            removeObserver()
            
            if let imageUrl = pin.getImageUrl() {
                ImageUtils.loadImage(forView: pinImageView, defaultImage: #imageLiteral(resourceName: "cancel"), url: imageUrl)
            } else {
                pinImageView.image = #imageLiteral(resourceName: "cancel")
            }
            
            if let lat = pin.location?.latitude,
               let lng = pin.location?.longitude {
                pinLocation = CLLocation(latitude: lat, longitude: lng)
                Location.getSubLocality(from: pinLocation!, success: { (address: String) in
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
            
            addObserver()
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
        titleLabel.textColor = UIConstants.Theme.titleBlack
        usernameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onNameTap)))
        actionsView.commentView.isHidden = true
        
        clockImageView.tintColor = UIColor.gray
    }
    
    deinit {
        removeObserver()
    }
    
    override func prepareForReuse() {
        actionsView.reset()
        pinLike = nil
        pinImageView.image = nil
    }

    @objc private func onNameTap(_ sender: UITapGestureRecognizer) {
        print("Put segue here")
    }
    
    @objc private func pinLikeLiveQueryHandler(_ notification: Notification) {
        if let likerId = PinLike.getCreatorIdFromNotification(notification), likerId != User.currentUser?.objectId!,
            let pinId = PinLike.getPinIdFromNotification(notification), pin != nil, pinId == pin.objectId!,
            let type = PinLike.getEventTypeFromNotification(notification) {
            likesCount += type == .like ? 1 : -1
            actionsView.updateLikesCount(animated: true, count: likesCount)
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pinLikeLiveQueryHandler),
                                               name: PinLike.pinLikeLiveQueryNotification,
                                               object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: PinLike.pinLikeLiveQueryNotification,
                                                  object: nil)
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
}
