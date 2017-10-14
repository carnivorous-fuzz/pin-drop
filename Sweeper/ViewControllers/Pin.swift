//
//  Pin.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Pin: NSObject {
    let blurb: String? // caption?
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let location: CLLocation? // TODO: is this the right data type?
    let message: String?
    let tags: [String]?
    let imageUrl: URL?
    
    init(dictionary: NSDictionary) {
        blurb = dictionary["blurb"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        if latitude != nil, longitude != nil {
            location = CLLocation(latitude: latitude!, longitude: longitude!)
        } else {
            location = nil
        }
        message = dictionary["message"] as? String
        
        let tagsStr = dictionary["tags"] as? String
        var tempTags = [String]()
        for tag in (tagsStr?.split(separator: ","))! {
            tempTags.append(tag.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        tags = tempTags
        
        let imageUrlStr = dictionary["image_url"] as? String
        if imageUrlStr != nil {
            imageUrl = URL(string: imageUrlStr!)!
        } else {
            imageUrl = nil
        }
    }
    
    class func pins(withArray: [NSDictionary]) -> [Pin] {
        var pins = [Pin]()
        for dictionary in withArray {
            let pin = Pin(dictionary: dictionary)
            pins.append(pin)
        }
        return pins
    }
}
