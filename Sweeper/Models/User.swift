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
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var caption: String?
    @NSManaged var profileImageUrl: URL?
    
    class var currentUser: User? {
        get {
            if (_currentUser == nil) {
                let query = PFQuery(className: "User")
                query.fromLocalDatastore()
                query.findObjectsInBackground(block: { (users: [PFObject]?, error: Error?) in
                    if error == nil {
                        _currentUser = users![0] as? User
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
            return _currentUser
        }
        set(user) {
            if user != nil { // save locally
                _currentUser = user
                _currentUser!.pinInBackground()
            } else { // logout
                _currentUser?.unpinInBackground()
                _currentUser = nil
            }
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
