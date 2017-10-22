//
//  Time.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import SwiftDate


class TimeUtils {
    static let components: [Calendar.Component] = [.day, .hour, .minute, .second]
    static let mapping: [Calendar.Component: String] = [.day: "d", .hour: "h", .minute: "m", .second: "s"]
    class func getPrettyTimeAgoString(_ time: Date) -> String {
        let times = time.timeIntervalSinceNow.in(components)
        
        for component in components {
            if let elapsedTime = times[component] {
                if abs(elapsedTime) > 0 {
                    return "\(abs(elapsedTime))\(mapping[component]!)"
                }
            }
        }
        
        return "Now"
    }
}
