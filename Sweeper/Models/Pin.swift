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
    
    // MARK: non-DB properties
    var imageUrl: URL?
    var latitude: Double?
    var longitude: Double?
    
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
