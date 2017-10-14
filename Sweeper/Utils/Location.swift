//
//  Location.swift
//  Sweeper
//
//  Created by Raina Wang on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import CoreLocation

struct Location {
    static var sharedInstance: CLGeocoder {
        struct Static {
            static let instance = CLGeocoder()
        }
        return Static.instance
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
