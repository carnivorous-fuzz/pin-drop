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
import ParseFacebookUtilsV4

class UserService {    
    static let sharedInstance = UserService()
    private static let permissions = ["public_profile"]
    
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
    
    func loginWithFacebook(completion: @escaping (User?, Error?) -> ()) {
        PFFacebookUtils.logInInBackground(withReadPermissions: UserService.permissions) { (pfUser, error) in
            if let pfUser = pfUser {
                do {
                    let user = try User.query()!.getObjectWithId(pfUser.objectId!) as! User
                    if pfUser.isNew {
                        let request = FBSDKGraphRequest(graphPath: "me", parameters: [:])
                        let connection = FBSDKGraphRequestConnection()
                        connection.add(request) { (requestConnection, result, connectionError) in
                            if connectionError == nil, let result = result as? NSDictionary {
                                //let ourUser = User(user: user)
                                if let fbId = result["id"] as? String {
                                    user.profileImageUrl = "https://graph.facebook.com/\(fbId)/picture?type=large&return_ssl_resources=1"
                                }
                                
                                if let name = result["name"] as? String {
                                    let parts = name.split(separator: " ")
                                    user.firstName = String(parts[0])
                                    if parts.count > 1 {
                                        user.lastName = String(parts[parts.count - 1])
                                    }
                                }
                                
                                User.currentUser = user
                                completion(user, nil)
                            } else {
                                completion(nil, connectionError)
                            }
                        }
                        connection.start()
                    } else {
                        User.currentUser = user
                        completion(user, nil)
                    }
                } catch {
                    completion(nil, LoginError.unknown)
                }
            } else {
                completion(nil, error)
            }
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

enum LoginError: Error {
    case unknown
}
