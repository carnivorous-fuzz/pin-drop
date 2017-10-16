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
import GoogleMaps

fileprivate extension PFGeoPoint {
    func toGMSMarker() -> GMSMarker {
        return GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
}

class Pin: PFObject, PFSubclassing {
    //MARK: DB properties
    @NSManaged var blurb: String?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var message: String?
    @NSManaged var imageUrlStr: String?
    @NSManaged var tagIds: [String]?
    
    private lazy var _marker: GMSMarker? = location == nil ? nil : location!.toGMSMarker()
    var marker: GMSMarker? {
        get {
            _marker?.title = "Message:"
            _marker?.snippet = message
            return _marker
        }
    }
    
    // MARK: non-DB properties
    var tags: [Tag]?
    var imageUrl: URL?
    var latitude: Double?
    var longitude: Double?
    
    override init() {
        super.init()
        
        let tagQuery = Tag.query()
        tagQuery!.whereKey("objectId", containedIn: tagIds ?? [])
        tagQuery!.findObjectsInBackground { (tags: [PFObject]?, error: Error?) in
            if error == nil {
                for tag in tags! {
                    let tag = tag as! Tag
                    self.tags?.append(tag)
                }
            } else {
                print("error fetching tags: \(error!.localizedDescription)")
            }
        }
        
        if imageUrlStr != nil {
            imageUrl = URL(string: imageUrlStr!)
        }
    }
    
    static func parseClassName() -> String {
        return "Pin"
    }
    
    override class func query() -> PFQuery<PFObject>? {
        let query = PFQuery(className: Pin.parseClassName())
        query.order(byDescending: "createdAt")
        return query
    }
    
    func setLocation() {
        if latitude != nil && longitude != nil {
            location = PFGeoPoint(latitude: latitude!, longitude: longitude!)
        } else {
            print("OH NO! Lat and long not set! Set both to use this function")
        }
    }
}
