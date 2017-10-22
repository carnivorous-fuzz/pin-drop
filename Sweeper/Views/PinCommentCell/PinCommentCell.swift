//
//  PinCommentCell.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class PinCommentCell: UITableViewCell {

    @IBOutlet weak var commenterLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}