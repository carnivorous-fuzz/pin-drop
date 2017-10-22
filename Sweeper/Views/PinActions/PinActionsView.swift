//
//  PinActionsView.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

protocol PinActionsViewDelegate: class {
    func pinActionsDidLike(_ pinActionsView: PinActionsView)
    func pinActionsDidComment(_ pinActionsView: PinActionsView)
}

class PinActionsView: UIView {

    @IBOutlet var actionsView: UIView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var delegate: PinActionsViewDelegate?
    
    private var likesCount = 0
    private var commentCount = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        UINib(nibName: "PinActionsView", bundle: nil).instantiate(withOwner: self, options: nil)
        actionsView.frame = bounds
        addSubview(actionsView)
        
        likeImageView.image = likeImageView.image?.withRenderingMode(.alwaysTemplate)
        likeImageView.tintColor = UIColor.gray
        commentImageView.image = commentImageView.image?.withRenderingMode(.alwaysTemplate)
        commentImageView.tintColor = UIColor.gray
        
        likeView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onLike))
        )
        
        commentView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onComment))
        )
    }
    
    func updateCommentIcon(toColor color: UIColor) {
        commentImageView.tintColor = color
    }
    
    func updateCommentsCount(animated: Bool, count: Int) {
        if commentCount != count {
            commentCount = count
            if animated {
                UIView.animate(withDuration: 0.1, animations: {
                    self.commentCountLabel.alpha = 0.0
                }, completion: { (finished) in
                    self.updateCommentsCount()
                    self.commentCountLabel.alpha = 1.0
                })
            } else {
                updateCommentsCount()
            }
        }
    }
    
    private func updateCommentsCount() {
        commentCountLabel.text = "\(commentCount)"
    }
    
    @objc private func onLike() {
        delegate?.pinActionsDidLike(self)
    }
    
    @objc private func onComment() {
        delegate?.pinActionsDidComment(self)
    }
}
