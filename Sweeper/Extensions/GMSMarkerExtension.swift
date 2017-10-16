//
//  GMSMarkerExtension.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import GoogleMaps

extension GMSMarker {
    func distanceFromUser() -> Double {
        guard let userLocation = map?.myLocation else {
            return Double.greatestFiniteMagnitude
        }
        
        let markerLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)
        let distance = markerLocation.distance(from: userLocation)
        print("~~~~Marker(title: \"\(title ?? "No title")\") is \(distance) meters away from user~~~~")
        return distance
    }
    
    func getLocation() -> CLLocation {
        return CLLocation(latitude: position.latitude, longitude: position.longitude)
    }
}
