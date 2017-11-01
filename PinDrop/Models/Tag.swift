//
//  Tag.swift
//  PinDrop
//
//  Created by Paul Sokolik on 10/15/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import Parse

class Tag: PFObject, PFSubclassing {
    @NSManaged var name: String?
    
    static func parseClassName() -> String {
        return "Tag"
    }
}
