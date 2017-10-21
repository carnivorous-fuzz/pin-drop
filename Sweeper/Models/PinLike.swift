//
//  PinLike.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/16/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import Parse

class PinLike: PFObject, PFSubclassing {
    @NSManaged var user: User?
    @NSManaged var toPin: Pin?
    
    static func parseClassName() -> String {
        return "PinLike"
    }
}
