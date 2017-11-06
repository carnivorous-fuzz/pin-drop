//
//  ViewedPin.swift
//  Pindrop
//
//  Created by Raina Wang on 10/15/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Parse

class ViewedPin: PFObject, PFSubclassing {
    @NSManaged var userId: String?
    @NSManaged var pinId: String?
    @NSManaged var user: User?
    @NSManaged var toPin: Pin?

    static func parseClassName() -> String {
        return "ViewedPin"
    }
}
