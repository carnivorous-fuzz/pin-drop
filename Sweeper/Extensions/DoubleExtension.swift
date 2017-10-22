//
//  DoubleExtension.swift
//  Sweeper
//
//  Created by Raina Wang on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//
import Foundation
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
