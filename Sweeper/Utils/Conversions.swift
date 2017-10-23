//
//  Conversions.swift
//  Sweeper
//
//  Created by Raina Wang on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation

struct Conversions {
    static func milesToKilometers(mile: Double) -> Double {
        let kilometer = mile * 1.60934
        return kilometer as Double
    }
}
