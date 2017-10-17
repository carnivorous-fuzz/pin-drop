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

class User: PFUser {
    static let userDidLogoutKey = "user_logged_out"
    
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var caption: String?
    @NSManaged var profileImageUrl: URL?
    
    private static var _currentUser: User?
    static var currentUser: User? {
        get {
            if _currentUser == nil {
                _currentUser = getStoredUser()
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            saveLocalUser(user: user, completion: nil)
        }
    }
    
    private class func getStoredUser() -> User? {
        let query = User.query()!.fromLocalDatastore()
        do {
            return try query.getFirstObject() as? User
        } catch {
            return nil
        }
    }
    
    class func saveLocalUser(user: User?, completion: ((Bool) -> Void)?) {
        if user != nil { // save locally
            user!.pinInBackground(block: { (success: Bool, error: Error?) in
                if success {
                    _currentUser = user
                }
                completion?(success)
            })
        } else { // logout
            _currentUser?.unpinInBackground(block: { (success: Bool, error: Error?) in
                _currentUser = nil
                completion?(success)
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
