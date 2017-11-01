//
//  LocationBanner.swift
//  PinDrop
//
//  Created by Raina Wang on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import CoreLocation

class LocationBanner: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addressLabel: UILabel!

    fileprivate var location: CLLocation!
    var subLocality: String?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }

    fileprivate func initSubViews() {
        let nib = UINib(nibName: "LocationBanner", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }

    func prepare(with currentLocation: CLLocation) {
        location = currentLocation
        Location.getAddress(from: location, success: { (address: String) in
            self.addressLabel.text = address
            Location.getSubLocality(from: self.location, success: { (subLocality: String) in
                self.subLocality = subLocality
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
}
