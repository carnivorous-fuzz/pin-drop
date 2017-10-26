//
//  PinAnnotationView.swift
//  Sweeper
//
//  Created by wuming on 10/17/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Mapbox

class PinAnnotationView: MGLAnnotationView {
    var pinImageView: UIImageView!
    var profileImageView: UIImageView!
    
    required init(reuseIdentifier: String?, pin: Pin) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        frame = CGRect(x: 0, y: 0, width: 50, height: 60)
        layer.borderColor = UIColor.clear.cgColor
        
        // pin image
        let image = UIImage(named: "location_blue")
        pinImageView = UIImageView(image: image)
        pinImageView.center = self.center
        pinImageView.bounds = self.bounds
        addSubview(pinImageView)
        
        // profile image
        if let profileImageUrl = pin.creator?.getImageUrl() {
            profileImageView = UIImageView()
            profileImageView.setImageWith(profileImageUrl)
        } else {
            let profileImage = UIImage(named: "default_profile")
            profileImageView = UIImageView(image: profileImage!)
        }
        
        profileImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileImageView.center = CGPoint(x: pinImageView.center.x, y:pinImageView.center.y - 6)
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
        pinImageView.addSubview(profileImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}
