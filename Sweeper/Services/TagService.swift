//
//  TagService.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/15/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import Parse

class TagService {
    static let sharedInstance = TagService()
    
    func createTags(forNames: [String], completion: @escaping ([Tag]?, Error?) -> Void) {
        // see if tags exist
        var trimmedTags = [String]()
        for name in forNames {
            // remove white spaces and include only unique names in final array
            let formattedName = name.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).lowercased()
            if !trimmedTags.contains(formattedName) {
                trimmedTags.append(formattedName)
            }
        }
        
        let tagsQuery = Pin.query() as! PFQuery<Tag>
        tagsQuery.whereKey("name", containedIn: trimmedTags)
        
        tagsQuery.findObjectsInBackground { (tags: [Tag]?, error: Error?) in
            print("fetched!")
            if error == nil {
                if tags!.count == trimmedTags.count { // all tags already existed, return
                    completion(tags, error)
                } else { // need to create new tags
                    var returnTags = tags!
                    var tagsToCreate = [Tag]()
                    let foundTags = returnTags.map({ $0.name! })
                    for tagName in trimmedTags {
                        if !foundTags.contains(tagName) {
                            let createTag = Tag()
                            createTag.name = tagName
                            tagsToCreate.append(createTag)
                        }
                    }
                
                    Tag.saveAll(inBackground: tagsToCreate, block: { (success: Bool, error: Error?) in
                        if success {
                            print(tagsToCreate)
                            returnTags = returnTags + tagsToCreate
                            completion(returnTags, error)
                        } else {
                            print("error creating tags: \(error!.localizedDescription)")
                        }
                    })
                    
                }
            } else {
                print("error fetching tags: \(error!.localizedDescription)")
            }
            
        }
    }
}
