//
//  User.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import Parse

var _currentUser: User?

class User: PFUser {
    static let userDidLogoutKey = "user_logged_out"
    
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var caption: String?
    @NSManaged var profileImageUrl: URL?
    
    static var currentUser: User? {
        get {
            return _currentUser
        }
    }
    
    class func getStoredUser(completion: @escaping (User?) -> Void) {
        let query = User.query()!.fromLocalDatastore()
        query.getFirstObjectInBackground { (user: PFObject?, error: Error?) in
            if error == nil {
                let user = user as? User
                _currentUser = user
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    class func saveLocalUser(user: User?, completion: @escaping (Bool) -> Void) {
        if user != nil { // save locally
            user!.pinInBackground(block: { (success: Bool, error: Error?) in
                if success {
                    _currentUser = user
                }
                completion(success)
            })
        } else { // logout
            _currentUser?.unpinInBackground(block: { (success: Bool, error: Error?) in
                _currentUser = nil
                completion(success)
            })
        }
    }
    
    func getFullName() -> (String) {
        var result = ""
        if self.firstName != nil {
            result += "\(self.firstName!)"
        }
        
        if self.lastName != nil {
            if result.characters.count > 0 {
                result += " "
            }
            result += "\(self.lastName!)"
        }
        return result
    }
}
