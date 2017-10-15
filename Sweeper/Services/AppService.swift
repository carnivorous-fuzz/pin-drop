//
//  AppService.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseLiveQuery

class AppService {
    static let sharedInstance = AppService()
    static let sharedClient = ParseLiveQuery.Client()
}
