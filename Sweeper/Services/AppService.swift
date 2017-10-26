//
//  AppService.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseLiveQuery

class AppService {
    static let sharedInstance = AppService()
    
    let client: Client = Client.shared
    lazy var pinLikeSubscription: Subscription<PinLike> = {
        let query = PinLike.query()!.whereKeyExists("user").order(byAscending: "createdAt") as! PFQuery<PinLike>
        let subscription = self.client.subscribe(query).handleEvent({ (query, event) in
            switch event {
            case .created(let pinLike):
                DispatchQueue.main.async {
                    self.didLikePin(pinLike)
                }
                break
            default:
                break
            }
        })
        return subscription
    }()
    
    func didLikePin(_ pinLike: PinLike) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(pinLike.likedPin!.objectId!), object: nil)
        }
    }
}
