//
//  TagSelectedCollectionCell.swift
//  Sweeper
//
//  Created by Raina Wang on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class TagSelectedCollectionCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    @IBOutlet weak var selectedTagLabel: UILabel!
    var selectedTag: Tag!
}
