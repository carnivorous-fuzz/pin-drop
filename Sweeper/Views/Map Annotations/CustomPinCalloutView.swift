//
//  CustomPinCalloutView.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/26/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class CustomPinCalloutView: UIView{

    @IBOutlet var contentView: UIView!
    var pin: Pin? {
        didSet {
            setLabels()
        }
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    // MARK - helper methods
    
    func setLabels() {
        
        if let lat = pin?.location?.latitude, let lng = pin?.location?.longitude {
            locationLabel.text = "\(lat.rounded(toPlaces: 2)), \(lng.rounded(toPlaces: 2))"
        }
        var prettyTags = ""
        if let tags = pin?.tags {
            var tagNames = [String]()
            for tag in tags {
                tagNames.append(tag.name!)
            }
            prettyTags = tagNames.joined(separator: ", ")
        }
        tagsLabel.text = prettyTags
        userLabel.text = pin?.creator?.getFullName()
        blurbLabel.text = pin?.blurb
//        commentsLabel.text = TODO
    }
    
    func loadViewFromNib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(contentView)
    }
}
