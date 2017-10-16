//
//  PinService.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseLiveQuery

var _pins: [Pin] = [Pin]()

class PinService {
    static let sharedInstance = PinService()

    func create(pin: Pin, withImage: UIImage?, tagNames: [String]?, completion: @escaping (Bool, Error?) -> Void) {
        TagService.sharedInstance.createTags(forNames: tagNames ?? [], completion: { (tags: [Tag]?, error: Error?) in
            if error == nil {
                let tagIds = tags!.map({ $0.objectId! })
                pin.tagIds = tagIds

                if withImage != nil {
                    let imageName = String.random(length: 10)
                    AWSS3Service.sharedInstance.uploadImage(for: imageName, with: UIImagePNGRepresentation(withImage!)!, completion: {
                        (task, error) -> Void in
                        let urlStr = "\(AWSConstans.S3BaseImageURL)\(imageName)"
                        pin.imageUrlStr = urlStr
                        pin.imageUrl = URL(string: urlStr)
                        pin.saveInBackground(block: { (success, error) in
                            completion(success, error)
                            _pins.append(pin)
                        })
                    })
                } else {
                    pin.imageUrlStr = nil
                    pin.saveInBackground(block: { (success, error) in
                        completion(success, error)
                        _pins.append(pin)
                    })
                }
            } else {
                print("error calling tagService.create")
            }
        })
    }
    
    func fetchPins(completion: @escaping ([Pin]?, Error?) -> Void) {
        //        client = ParseLiveQuery.Client()
        //        TODO: subscription livequery closure
        
        let pinsQuery = Pin.query() as! PFQuery<Pin>
        pinsQuery.order(byDescending: "createdAt")
        
        pinsQuery.findObjectsInBackground { (pins: [Pin]?, error: Error?) in
            print("fetched!")
            if pins != nil {
                _pins = pins!
            }
            completion(pins, error)
        }
    }
}
