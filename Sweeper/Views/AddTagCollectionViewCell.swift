//
//  AddTagCollectionViewCell.swift
//  Sweeper
//
//  Created by Raina Wang on 10/27/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

@objc protocol AddTagCollectionViewCellDelegate {
    @objc optional func removeTag(addTagCollectionViewCell: AddTagCollectionViewCell, didRemoveTag tag: String)
}

class AddTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    var delegate: AddTagCollectionViewCellDelegate?

    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        let origCloseImage = UIImage(named: "exit")
        let tintedImage = origCloseImage?.withRenderingMode(.alwaysTemplate)
        removeButton.setImage(tintedImage, for: .normal)
        removeButton.tintColor = UIConstants.Theme.green
    }
    @IBAction func removeTag(_ sender: Any) {
        delegate?.removeTag?(addTagCollectionViewCell: self, didRemoveTag: tagLabel.text!)
    }
}
