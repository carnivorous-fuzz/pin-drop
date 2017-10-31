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
    
    // fetches EITHER visited pins OR un-visited pins. Always fetches near indicated location. Never gets user's created pins.
    func fetchPins(for user: User, visited: Bool, near: CLLocation?, completion: @escaping ([Pin]?, Error?) -> Void) {
        var viewedPinIds = [String]()
        let viewedPinsQuery = ViewedPin.query() as! PFQuery<ViewedPin>
        viewedPinsQuery.whereKey("userId", equalTo: user.objectId!)
        viewedPinsQuery.selectKeys(["pinId"])
        viewedPinsQuery.findObjectsInBackground { (viewedPins: [ViewedPin]?, error: Error?) in
            if viewedPins != nil {
                for viewedPin in viewedPins! {
                    viewedPinIds.append(viewedPin.pinId!)
                }

                let pinsQuery = Pin.query() as! PFQuery<Pin>
                pinsQuery.order(byDescending: "createdAt")
                pinsQuery.limit = 20
                pinsQuery.includeKey("tags")
                pinsQuery.includeKey("creator")
                let defaultLocation = CLLocation(latitude: 37.787353, longitude: -122.421561)
                pinsQuery.whereKey("location", nearGeoPoint: PFGeoPoint(location: (near ?? defaultLocation)))
                pinsQuery.whereKey("creator", notEqualTo: user)
                
                if visited {
                    pinsQuery.whereKey("objectId", containedIn: viewedPinIds)
                } else {
                    pinsQuery.whereKey("objectId", notContainedIn: viewedPinIds)
                }
                
                pinsQuery.clearCachedResult()
                
                pinsQuery.findObjectsInBackground { (pins: [Pin]?, error: Error?) in
                    if pins != nil {
                        for pin in pins! {
                            pin.visited = visited
                        }
                        _pins = pins!
                    }
                    completion(pins, error)
                }
            }
        }
    }

    func fetchPins(with tags: [Tag], in radius: Double, for currentLocation: CLLocation, count: NSNumber, completion: @escaping ([Pin]?, Error?) -> Void) {
        let userGeo:PFGeoPoint = PFGeoPoint(location: currentLocation)

        let pinsQuery = Pin.query() as! PFQuery<Pin>
        pinsQuery.limit = 20
        pinsQuery.whereKey("tags", containedIn: tags)
        pinsQuery.whereKey("location", nearGeoPoint: userGeo, withinRadians: radius)
        pinsQuery.clearCachedResult()
        pinsQuery.findObjectsInBackground { (pins: [Pin]?, error: Error?) in
            if let pins = pins {
                var filteredOutPins: [Pin] = []
                // filter out pins that within certain range
                var filteredPins = pins.filter { index in
                    var repeatedCount = 0
                    pins.forEach{
                        let distance = $0.location?.distanceInKilometers(to: index.location)
                        if distance!.rounded(toPlaces: 2) == 0 {
                            repeatedCount += 1
                        }
                    }

                    if repeatedCount != 1 {
                        filteredOutPins.append(index)
                    }
                    return repeatedCount == 1
                }

                let finalPins: [Pin]

                if count.intValue < filteredPins.count {
                    // pins returned more than user selected
                    filteredPins.shuffle()
                    finalPins = filteredPins.choose(count.intValue)
                } else {
                    // pins returned less than user selected
                    finalPins = filteredPins
                }
                completion(finalPins, error)
            } else {
                completion(nil, error)
            }
        }
    }

    func fetchPins(by user: User, completion: @escaping ([Pin]?, Error?) -> Void) {
        let pinsQuery = Pin.query() as! PFQuery<Pin>
        pinsQuery.order(byDescending: "createdAt")
        pinsQuery.includeKey("tags")
        pinsQuery.includeKey("creator")
        pinsQuery.whereKey("creator", equalTo: user)
        pinsQuery.clearCachedResult()
        
        pinsQuery.findObjectsInBackground { (pins: [Pin]?, error: Error?) in
            completion(pins, error)
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
        pin.visited = true
        
        // don't duplicate "viewed" records
        let viewedPinsQuery = ViewedPin.query() as! PFQuery<ViewedPin>
        viewedPinsQuery.whereKey("userId", equalTo: user.objectId!)
        viewedPinsQuery.whereKey("pinId", equalTo: pin.objectId!)
        viewedPinsQuery.getFirstObjectInBackground { (existingViewedPin: ViewedPin?, error: Error?) in
            if existingViewedPin == nil {
                viewedPin.saveInBackground()
            }
        }
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
    
    func visitedPinCount(_ forUser: User, completion: @escaping (Int) -> ()) {
        let query = ViewedPin.query() as! PFQuery<ViewedPin>
        query.whereKey("user", equalTo: forUser)
        query.countObjectsInBackground { (count: Int32, error: Error?) in
            completion(Int(count))
        }
    }
}
