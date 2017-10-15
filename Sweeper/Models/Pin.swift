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
    @NSManaged var blurb: String?
    @NSManaged var latitude: NSDecimalNumber?
    @NSManaged var longitude: NSDecimalNumber?
    @NSManaged var location: CLLocation? // TODO: is this the right data type?
    @NSManaged var message: String?
    @NSManaged var imageUrl: URL?
    //@NSManaged var tags: [String]?
    
    static func parseClassName() -> String {
        return "Pin"
    }

}
