//
//  Pin.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Pin: PFObject, PFSubclassing {
    //MARK: DB properties
    @NSManaged var userId: String?
    @NSManaged var creator: User?
    @NSManaged var blurb: String?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var message: String?
    @NSManaged var imageUrlStr: String?
    @NSManaged var tagIds: [String]?
    @NSManaged var tags: [Tag]?
    
    //lazy var marker: PinMarker? = location == nil ? nil : PinMarker(fromPin: self)
    
    // MARK: non-DB properties
//    var tags: [Tag]?
    var imageUrl: URL?
    var latitude: Double?
    var longitude: Double?
    
//    override init() {
//        super.init()
//
//        let tagQuery = Tag.query()
//        tagQuery!.whereKey("objectId", containedIn: tagIds ?? [])
//        tagQuery!.findObjectsInBackground { (tags: [PFObject]?, error: Error?) in
//            if error == nil {
//                for tag in tags! {
//                    let tag = tag as! Tag
//                    self.tags?.append(tag)
//                }
//            } else {
//                print("error fetching tags: \(error!.localizedDescription)")
//            }
//        }
//
//        if imageUrlStr != nil {
//            imageUrl = URL(string: imageUrlStr!)
//        }
//    }
    
    static func parseClassName() -> String {
        return "Pin"
    }
    
    func setLocation() {
        if latitude != nil && longitude != nil {
            location = PFGeoPoint(latitude: latitude!, longitude: longitude!)
        } else {
            print("OH NO! Lat and long not set! Set both to use this function")
        }
    }
}

//class PinMarker: GMSMarker {
//    weak var pin: Pin!
//
//    convenience init(fromPin pin: Pin) {
//        self.init(position: CLLocationCoordinate2D(latitude: (pin.location?.latitude)!, longitude: (pin.location?.longitude)!))
//        self.pin = pin
//        snippet = self.pin.message
//        title = "Message:"
//        icon = #imageLiteral(resourceName: "default_profile")
//    }
//
//    func distanceFromUser() -> Double {
//        guard let userLocation = map?.myLocation else {
//            return Double.greatestFiniteMagnitude
//        }
//
//        let markerLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)
//        let distance = markerLocation.distance(from: userLocation)
//        print("~~~~Marker(title: \"\(title ?? "No title")\") is \(distance) meters away from user~~~~")
//        return distance
//    }
//
//    func getLocation() -> CLLocation {
//        return CLLocation(latitude: position.latitude, longitude: position.longitude)
//    }
//}

