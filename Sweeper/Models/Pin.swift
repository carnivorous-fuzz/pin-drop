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
import CoreLocation

class Pin: PFObject, PFSubclassing {
    //MARK: DB properties
    @NSManaged var blurb: String?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var message: String?
    @NSManaged var imageUrlStr: String?
    @NSManaged var tagIds: [String]?
    
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
    
    func setLocation() {
        if latitude != nil && longitude != nil {
            location = PFGeoPoint(latitude: latitude!, longitude: longitude!)
        } else {
            print("OH NO! Lat and long not set! Set both to use this function")
        }
    }
}
