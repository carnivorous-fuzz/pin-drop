//
//  UserService.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import Parse

class UserService {    
    static let sharedInstance = UserService()
    
    func signUp(username: String, password: String, firstName: String, lastName: String, image: UIImage?, completion: @escaping (Error?) -> Void) {
        if let image = image {
            let imageString = String.random(length: 12)
            AWSS3Service.sharedInstance.uploadImage(for: imageString, with: UIImagePNGRepresentation(image)!, completion: { (task, error) in
                if error == nil {
                    let url = "\(AWSConstants.S3BaseImageURL)\(imageString)"
                    print(url)
                    self.signUp(username: username, password: password, firstName: firstName, lastName: lastName, imageUrl: url, completion: completion)
                } else {
                    completion(error)
                }
            })
        } else {
            self.signUp(username: username, password: password, firstName: firstName, lastName: lastName, imageUrl: nil, completion: completion)
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (pfUser, error) in
            var user: User?
            var success = false
            if pfUser != nil {
                user = pfUser as? User
                // store user in local storage
                User.currentUser = user
                success = true
            }
            completion(success, error)
        }
    }
    
    // remove stored user. View controller is responsible for view segue
    func logout() {
        User.logOut() // this will automatically set current user to nil
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: User.userDidLogoutKey)))
    }
    
    private func signUp(username: String, password: String, firstName: String, lastName: String, imageUrl: String?, completion: @escaping (Error?) -> ()) {
        let user = User()
        user.username = username
        user.password = password
        user.firstName = firstName
        user.lastName = lastName
        user.profileImageUrl = imageUrl
        
        user.signUpInBackground(block: { (success, error) in
            if success {
                User.currentUser = user
            }
            completion(error)
        })
    }
}
