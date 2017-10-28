//
//  TagSelectedCollectionCell.swift
//  Sweeper
//
//  Created by Raina Wang on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
@objc protocol TagSelectedCollectionCellDelegate {
    @objc optional func removeTag(tagSelectedCollectionCell: TagSelectedCollectionCell, didRemoveTag tag: Tag)
}

class TagSelectedCollectionCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var selectedTagLabel: UILabel!
    var selectedTag: Tag!
    var delegate: TagSelectedCollectionCellDelegate?

    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        let origCloseImage = UIImage(named: "exit")
        let tintedImage = origCloseImage?.withRenderingMode(.alwaysTemplate)
        removeButton.setImage(tintedImage, for: .normal)
        removeButton.tintColor = UIConstants.Theme.green
    }
    @IBAction func removeTag(_ sender: Any) {
        delegate?.removeTag?(tagSelectedCollectionCell: self, didRemoveTag: self.selectedTag)
    }
}
