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
    // MARK: Static properties
    static let pinLiveQueryNotification = Notification.Name("pin-livequery-notification")
    static let pinKey = "pin-notification-key"
    
    // MARK: DB properties
    @NSManaged var userId: String?
    @NSManaged var creator: User?
    @NSManaged var blurb: String?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var locationName: String?
    @NSManaged var message: String?
    @NSManaged var imageUrlStr: String?
    @NSManaged var tagIds: [String]?
    @NSManaged var tags: [Tag]?
    
    // MARK: non-DB properties
    var visited: Bool?
    var imageUrl: URL?
    var latitude: Double?
    var longitude: Double?
    
    // MARK: Static functions
    static func parseClassName() -> String {
        return "Pin"
    }
    
    static func getPinFromNotification(_ notification: Notification) -> Pin? {
        guard let pin = notification.userInfo?[pinKey] as? Pin else {
            return nil
        }
        
        return pin
    }
    
    // MARK: Helpers
    func setLocation() {
        if latitude != nil && longitude != nil {
            location = PFGeoPoint(latitude: latitude!, longitude: longitude!)
        } else {
            print("OH NO! Lat and lng not set! Set both to use this function")
        }
    }
    
    func getImageUrl() -> URL? {
        if let imageUrlStr = imageUrlStr {
            return URL(string: imageUrlStr)
        } else {
            return nil
        }
    }
}
