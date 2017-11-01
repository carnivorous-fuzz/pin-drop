//
//  PinAnnotation.swift
//  PinDrop
//
//  Created by wuming on 10/17/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Mapbox

class PinAnnotation: MGLPointAnnotation {
    
    weak var pin: Pin!
    lazy var location: CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    
    convenience init(fromPin pin: Pin) {
        self.init()
        self.pin = pin
        
        title = "\(pin.blurb!)"
        subtitle = pin.message
        
        if let location = pin.location {
            coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
}
