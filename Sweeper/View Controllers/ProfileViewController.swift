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
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if user == nil {
            user = User.currentUser
        }
        
        // don't show "edit" button if we're viewing someone else's profile
        if user == User.currentUser {
            editProfileButton.backgroundColor = Theme.Colors().green
            editProfileButton.layer.cornerRadius = 7
            editProfileButton.layer.borderWidth = 1
            editProfileButton.layer.borderColor = Theme.Colors().lightGray.cgColor
        } else {
            editProfileButton.isHidden = true
        }
        
        if let imageUrl = user.getImageUrl() {
            profileImageView.setImageWith(imageUrl)
        } else {
            profileImageView.image = UIImage(named: "default_profile")
        }
        nameLabel.text = user.getFullName()
        usernameLabel.text = user.username ?? ""
        emailLabel.text = user.email ?? "youremail@you.com"
    }

}
