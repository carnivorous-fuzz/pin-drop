//
//  CollectionViewPinCell
//  PinDrop
//
//  Created by Paul Sokolik on 10/23/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class CollectionViewPinCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var pin: Pin! {
        didSet {
            if let imageUrl = pin.getImageUrl() {
                imageView.setImageWith(imageUrl)
            }
        }
    }
    
}
