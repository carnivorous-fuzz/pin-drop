//
//  ProfileView.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/15/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    fileprivate func initSubviews() {
        UINib(nibName: "ProfileView", bundle: nil).instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2.0
        profileImageView.clipsToBounds = true
        
        // TODO: Remove this section
        profileImageView.image = #imageLiteral(resourceName: "default_profile")
        usernameLabel.text = User.currentUser?.username ?? "No username"
    }
    
    func prepare(with user: User) {
        // TODO: Fix profile image once that is complete
        profileImageView.image = #imageLiteral(resourceName: "default_profile")
        usernameLabel.text = user.username
    }
}
