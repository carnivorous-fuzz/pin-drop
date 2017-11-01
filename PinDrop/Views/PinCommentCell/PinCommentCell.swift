//
//  PinCommentCell.swift
//  PinDrop
//
//  Created by Wuming Xie on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class PinCommentCell: UITableViewCell {

    @IBOutlet weak var commenterLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    func prepare(withComment comment: PinComment) {
        commenterLabel.text = comment.user?.getFullName() ?? "Anon"
        commentLabel.text = comment.comment
        timeAgoLabel.text = TimeUtils.getPrettyTimeAgoString(comment.createdAt!)
    }

    override func prepareForReuse() {
        commentLabel.text = nil
        commenterLabel.text = nil
        timeAgoLabel.text = nil
    }
}
