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

var _pinsQuery: PFQuery<Pin> {
    return Pin.query()!
        .order(byDescending: "createdAt") as! PFQuery<Pin>
}

class PinService {
    static let sharedInstance = PinService()
    
    func create(pin: Pin, completion: @escaping (Bool, Error?) -> Void) {
        pin.saveInBackground { (success: Bool, error: Error?) in
            completion(success, error)
        }
        
        // TODO: append pin to local pins collection
    }
    
    func fetchPins(completion: @escaping ([Pin]?, Error?) -> Void) {
//        client = ParseLiveQuery.Client()
//        TODO: subscription closure
//        subscription = client.subscribe(query)
//            // handle creation events, we can also listen for update, leave, enter events
//            .handle(Event.created) { _, message in
//                DispatchQueue.main.async {
//                    print(message.text!)
//                    self.messages!.insert(message, at: 0)
//                    self.tableView.reloadData()
//                }
//        }
        
        _pinsQuery.findObjectsInBackground { (pins: [Pin]?, error: Error?) in
            print("fetched!")
            completion(pins, error)
        }
        
        // TODO: set pins collection
    }
    
}
