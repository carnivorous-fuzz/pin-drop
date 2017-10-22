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
    
    func prepare(withPin: Pin) {
        
    }
    
    @objc private func onLike() {
        delegate?.pinActionsDidLike(self)
    }
    
    @objc private func onComment() {
        delegate?.pinActionsDidComment(self)
    }
}
