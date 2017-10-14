//
//  User.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    let firstName: String?
    let lastName: String?
    let email: String?
    let caption: String?
    let profileImageUrl: URL?
    
    init(dictionary: NSDictionary) {
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        email = dictionary["email"] as? String
        caption = dictionary["caption"] as? String
        
        let imageUrlStr = dictionary["profile_image_url"] as? String
        if imageUrlStr != nil {
            profileImageUrl = URL(string: imageUrlStr!)!
        } else {
            profileImageUrl = nil
        }
    }
    
    class func users(withArray: [NSDictionary]) -> [User] {
        var users = [User]()
        for dictionary in withArray {
            let user = User(dictionary: dictionary)
            users.append(user)
        }
        return users
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
