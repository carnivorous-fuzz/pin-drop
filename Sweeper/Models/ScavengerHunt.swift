//
//  ScavengerHunt.swift
//  Sweeper
//
//  Created by Raina Wang on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import Parse

class ScavengerHunt: NSObject{
    var radius: NSNumber?
    var pinCount: NSNumber?
    var user: User?
    var pins: [Pin]?
    var selectedTags: [Tag]?
}
