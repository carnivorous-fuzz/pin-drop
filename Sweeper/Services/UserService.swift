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
    
    func signup(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let pfUser = PFUser()
        pfUser.username = username
        pfUser.password = password
        
        pfUser.signUpInBackground(block: { (success, error) in
            if success {
                let user = pfUser as? User
                // store user in local storage
                User.saveLocalUser(user: user, completion: { (success: Bool) in
                    print("hello?")
                })
            }
            completion(success, error)
        })
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (pfUser, error) in
            var user: User?
            var success = false
            if pfUser != nil {
                user = pfUser as? User
                // store user in local storage
                User.saveLocalUser(user: user, completion: { (success: Bool) in
                    print("hello?")
                })
                success = true
            }
            completion(success, error)
        }
    }
}
