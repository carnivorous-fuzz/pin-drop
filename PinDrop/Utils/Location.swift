//
//  Location.swift
//  PinDrop
//
//  Created by Raina Wang on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import CoreLocation

let METERS_PER_MILE = 1609.34

struct Location {
    static var sharedInstance: CLGeocoder {
        struct Static {
            static let instance = CLGeocoder()
        }
        return Static.instance
    }
    
    static func getPrettyDistance(loc1: CLLocation, loc2: CLLocation) -> String {
        let meters = loc1.distance(from: loc2)
        let miles = Double(meters) / METERS_PER_MILE
        let rounded = round(miles * 10) / 10
        let roundedStr = String(rounded)
        return "\(roundedStr)mi"
    }

    static func getSubLocality(from location: CLLocation, success: @escaping (String) -> (), failure: @escaping (Error) -> ()) {

        let ceo = self.sharedInstance

        ceo.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error != nil {
                failure(error!)
            }

            let pm = placemarks! as [CLPlacemark]
            var addressString : String = ""

            if pm.count > 0 {
                let pm = placemarks![0]

                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality!
                }
            }

            success(addressString)
        })
    }

    static func getAddress(from location: CLLocation, success: @escaping (String) -> (), failure: @escaping (Error) -> ()) {
        let ceo = self.sharedInstance
        
        ceo.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error != nil {
                failure(error!)
            }

            let pm = placemarks! as [CLPlacemark]
            var addressString : String = ""

            if pm.count > 0 {
                let pm = placemarks![0]

                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
            }

            success(addressString)
        })
    }
}
