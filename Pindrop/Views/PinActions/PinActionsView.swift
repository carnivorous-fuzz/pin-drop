//
//  PinActionsView.swift
//  Pindrop
//
//  Created by Wuming Xie on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

@objc protocol PinActionsViewDelegate: class {
    @objc optional func pinActionsDidLike(_ pinActionsView: PinActionsView)
    @objc optional func pinActionsDidComment(_ pinActionsView: PinActionsView)
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
        commentImageView.image = commentImageView.image?.withRenderingMode(.alwaysTemplate)
        
        reset()
        
        likeView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onLike))
        )
        
        commentView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onComment))
        )
    }
    
    func reset() {
        likeImageView.image = #imageLiteral(resourceName: "heart_open")
        likeImageView.tintColor = UIColor.gray
        commentImageView.tintColor = UIColor.gray
        likesCount = 0
        updateLikesCount()
        commentCount = 0
        updateCommentsCount()
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
    
    func updateLikeIcon(animated: Bool, liked: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.likeImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { (finished) in
                self.updateLikesCount(animated: true, count: liked ? self.likesCount + 1 : self.likesCount - 1)
                UIView.animate(withDuration: 0.2) {
                    self.updateLikeIcon(liked: liked)
                    self.likeImageView.transform = CGAffineTransform.identity
                }
            }
        } else {
            self.updateLikeIcon(liked: liked)
        }
    }
    
    func updateLikesCount(animated: Bool, count: Int) {
        if likesCount != count {
            likesCount = count
            if animated {
                UIView.animate(withDuration: 0.2, animations: {
                    self.likeCountLabel.alpha = 0.0
                }) { (finished) in
                    UIView.animate(withDuration: 0.2) {
                        self.updateLikesCount()
                        self.likeCountLabel.alpha = 1.0
                    }
                }
            } else {
                updateLikesCount()
            }
        }
    }
    
    private func updateCommentsCount() {
        commentCountLabel.text = "\(commentCount)"
    }
    
    private func updateLikesCount() {
        likeCountLabel.text = "\(likesCount)"
    }
    
    private func updateLikeIcon(liked: Bool) {
        let color = liked ? UIColor.red : UIColor.gray
        likeImageView.image = liked ? #imageLiteral(resourceName: "heart_filled") : #imageLiteral(resourceName: "heart_open")
        likeImageView.tintColor = color
    }
    
    @objc private func onLike() {
        delegate?.pinActionsDidLike?(self)
    }
    
    @objc private func onComment() {
        delegate?.pinActionsDidComment?(self)
    }
}
