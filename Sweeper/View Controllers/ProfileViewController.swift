//
//  ProfileViewController.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    fileprivate var user: User! = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editProfileButton.backgroundColor = Theme.Colors().green
        editProfileButton.layer.cornerRadius = 7
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = (Theme.Colors().lightGray as! CGColor)
        
        if user.profileImageUrl != nil {
            profileImageView.setImageWith(user.profileImageUrl!)
        }
        nameLabel.text = user.getFullName()
        usernameLabel.text = user.username ?? ""
        emailLabel.text = user.email ?? ""
    }

}
