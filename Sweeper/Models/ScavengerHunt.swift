//
//  ScavengerHunt.swift
//  Sweeper
//
//  Created by Raina Wang on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import Parse

class ScavengerHunt: PFObject, PFSubclassing {
    @NSManaged var radius: NSNumber?
    @NSManaged var pinCount: NSNumber?
    @NSManaged var user: User?
    @NSManaged var pins: [Pin]?
    @NSManaged var selectedTags: [Tag]?

    static func parseClassName() -> String {
        return "ScavengerHunt"
    }
}
