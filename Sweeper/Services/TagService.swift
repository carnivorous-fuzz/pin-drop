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
            if !formattedName.isEmpty && !trimmedTags.contains(formattedName) {
                trimmedTags.append(formattedName)
            }
        }
        
        let tagsQuery = Tag.query() as! PFQuery<Tag>
        tagsQuery.whereKey("name", containedIn: trimmedTags)
        
        tagsQuery.findObjectsInBackground { (tags: [Tag]?, error: Error?) in
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

    func fetchTags(with page: Int, completion: @escaping ([Tag]?, Error?) -> Void) {
        // How much you want on a page
        let displayLimit = 10
        let query = Tag.query() as! PFQuery<Tag>
        query.limit = displayLimit
        query.skip = page * displayLimit
        query.order(byDescending: "createdAt")

        query.findObjectsInBackground { (tags: [Tag]?, error: Error?) in
            completion(tags, error)
        }
    }

    func search(with term: String, completion: @escaping ([Tag]?, Error?) -> Void) {
        let query = Tag.query() as! PFQuery<Tag>
        query.order(byDescending: "createdAt")
        query.whereKey("name", equalTo: term.lowercased())
        query.findObjectsInBackground { (tags: [Tag]?, error: Error?) in
            completion(tags, error)
        }
    }
}
