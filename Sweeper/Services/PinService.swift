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
        pin.creator = User.currentUser
        TagService.sharedInstance.createTags(forNames: tagNames ?? [], completion: { (tags: [Tag]?, error: Error?) in
            if error == nil {
                let tagIds = tags!.map({ $0.objectId! })
                pin.tagIds = tagIds
                pin.tags = tags

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
        pinsQuery.includeKey("tags")
        pinsQuery.includeKey("creator")
        pinsQuery.clearCachedResult()
        
        pinsQuery.findObjectsInBackground { (pins: [Pin]?, error: Error?) in
            if pins != nil {
                _pins = pins!
            }
            completion(pins, error)
        }
    }

    func fetchPins(with tags: [Tag], in radius: Double, for currentLocation: CLLocation, completion: @escaping ([Pin]?, Error?) -> Void) {
        let userGeo:PFGeoPoint = PFGeoPoint(location: currentLocation)
        let kiloRadius: Double = Conversions.milesToKilometers(mile: radius)
        let pinsQuery = Pin.query() as! PFQuery<Pin>

        pinsQuery.limit = 5
        pinsQuery.whereKey("tags", containedIn: tags)
        pinsQuery.whereKey("location", nearGeoPoint: userGeo, withinKilometers: kiloRadius)
        pinsQuery.clearCachedResult()
        pinsQuery.findObjectsInBackground { (pins: [Pin]?, error: Error?) in
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
        viewedPin.user = user
        viewedPin.pinId = pin.objectId
        viewedPin.toPin = pin
        viewedPin.saveInBackground()
    }
    
    func getComments(forPin pin: Pin, completion: @escaping ([PinComment]?, Error?) -> ()) {
        let commentsQuery = PinComment.query() as! PFQuery<PinComment>
        commentsQuery.whereKey("commentedPin", equalTo: pin)
        commentsQuery.addDescendingOrder("createdAt")
        commentsQuery.findObjectsInBackground(block: { (pinComments, error) in
            if let pinComments = pinComments {
                completion(pinComments, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    func commentedOnPin(_ pin: Pin, completion: @escaping (Bool) -> ()) {
        if let commentsQuery = PinComment.query() as? PFQuery<PinComment> {
            commentsQuery.whereKey("user", equalTo: User.currentUser as Any)
            commentsQuery.whereKey("commentedPin", equalTo: pin)
            commentsQuery.countObjectsInBackground(block: { (count, error) in
                completion(count > 0)
            })
        }
    }
    
    func likesOnPin(_ pin: Pin, completion: @escaping (Int) -> ()) {
        if let likesQuery = PinLike.query() as? PFQuery<PinLike> {
            likesQuery.whereKey("likedPin", equalTo: pin)
            .countObjectsInBackground(block: { (count, error) in
                completion(Int(count))
            })
        }
    }
    
    func likedPin(_ pin: Pin, completion: @escaping (PinLike?) -> ()) {
        if let likesQuery = PinLike.query() as? PFQuery<PinLike> {
            likesQuery.whereKey("likedPin", equalTo: pin)
                .whereKey("user", equalTo: User.currentUser as Any)
                .findObjectsInBackground(block: { (pinLikes, error) in
                    completion(pinLikes?[0])
                })
        }
    }
}
