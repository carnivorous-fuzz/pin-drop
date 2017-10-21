//
//  PinDetailsView.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class PinDetailsCard: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var pin: Pin!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        UINib(nibName: "PinDetailsCard", bundle: nil).instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        imageScrollView.contentInsetAdjustmentBehavior = .never
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.image = #imageLiteral(resourceName: "default_profile")
    }
    
    func prepare(withPin pin: Pin) {
        self.pin = pin
        imageView.image = nil
        if let imageUrlStr = pin.imageUrlStr {
            ImageUtils.loadImage(forView: imageView, defaultImage: nil, url: URL(string: imageUrlStr)!)
        }
        
        titleLabel.text = pin.blurb
        messageLabel.text = pin.message
        nameLabel.text = pin.creator?.username
    }
}
