//
//  PinService.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseLiveQuery

var _pins: [Pin] = [Pin]()

class PinService {
    static let sharedInstance = PinService()

    func create(pin: Pin, withImage: UIImage?, tagNames: [String]?, completion: @escaping (Bool, Error?) -> Void) {
        pin.userId = User.currentUser?.objectId
        TagService.sharedInstance.createTags(forNames: tagNames ?? [], completion: { (tags: [Tag]?, error: Error?) in
            if error == nil {
                let tagIds = tags!.map({ $0.objectId! })
                pin.tagIds = tagIds

                if withImage != nil {
                    let imageName = String.random(length: 10)
                    AWSS3Service.sharedInstance.uploadImage(for: imageName, with: UIImagePNGRepresentation(withImage!)!, completion: {
                        (task, error) -> Void in
                        let urlStr = "\(AWSConstants.S3BaseImageURL)\(imageName)"
                        pin.imageUrlStr = urlStr
                        pin.imageUrl = URL(string: urlStr)
                        pin.saveInBackground(block: { (success, error) in
                            completion(success, error)
                            _pins.append(pin)
                        })
                    })
                } else {
                    pin.imageUrlStr = nil
                    pin.saveInBackground(block: { (success, error) in
                        completion(success, error)
                        _pins.append(pin)
                    })
                }
            } else {
                print("error calling tagService.create")
            }
        })
    }
    
    func fetchPins(completion: @escaping ([Pin]?, Error?) -> Void) {
//      client = ParseLiveQuery.Client()
//      TODO: subscription livequery closure
        
        let pinsQuery = Pin.query() as! PFQuery<Pin>
        pinsQuery.order(byDescending: "createdAt")
        pinsQuery.limit = 20
        pinsQuery.clearCachedResult()
        
        pinsQuery.findObjectsInBackground { (pins: [Pin]?, error: Error?) in
            print("fetched!")
            if pins != nil {
                _pins = pins!
            }
            completion(pins, error)
        }
    }

    func fetchArchievedPins(for user: User, completion: @escaping ([Pin], Error?) -> Void) {
        var viewedPinIds = [String]()
        let viewedPinsQuery = ViewedPin.query() as! PFQuery<ViewedPin>
        viewedPinsQuery.whereKey("userId", equalTo: user.objectId!)
        viewedPinsQuery.findObjectsInBackground { (viewedPins: [ViewedPin]?, error: Error?) in
            if viewedPins != nil {
                for viewedPin in viewedPins! {
                    viewedPinIds.append(viewedPin.pinId!)
                }

                let pinQuery = Pin.query() as! PFQuery<Pin>

                pinQuery.whereKey("objectId", containedIn: viewedPinIds)
                pinQuery.findObjectsInBackground(block: { (pins: [Pin]?, error: Error?) in
                    if pins != nil {
                        completion(pins!, error)
                    }
                })
            }
        }
    }

    func hasViewed(by user: User, with pin: Pin, completion: @escaping (Bool, Error?) -> Void) {
        let viewedPinsQuery = ViewedPin.query() as! PFQuery<ViewedPin>
        viewedPinsQuery.whereKey("userId", equalTo: user.objectId!)
        viewedPinsQuery.whereKey("pinId", equalTo: pin.objectId!)

        viewedPinsQuery.getFirstObjectInBackground(block: { (viewedPin: ViewedPin?, error: Error?) in
            if viewedPin != nil {
                completion(true, error)
            } else {
                completion(false, error)
            }
        })
    }

    func markAsViewed(by user: User, with pin: Pin) {
        let viewedPin = ViewedPin()
        viewedPin.userId = user.objectId
        viewedPin.pinId = pin.objectId
        viewedPin.saveInBackground()
    }
}
