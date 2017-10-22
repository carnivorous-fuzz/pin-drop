//
//  PinComment.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import Parse

class PinComment: PFObject {
    
    @NSManaged var user: User?
    @NSManaged var commentedPin: Pin?
    @NSManaged var comment: String?
    
}

extension PinComment: PFSubclassing {
    static func parseClassName() -> String {
        return "PinComment"
    }
}
