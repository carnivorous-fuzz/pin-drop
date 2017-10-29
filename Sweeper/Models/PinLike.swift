//
//  PinLike.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/16/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import Parse

enum PinLikeLiveQueryEventType {
    case like, unlike
}

class PinLike: PFObject, PFSubclassing {
    static let pinIdKey = "pinlike-likedpinid-key"
    static let typeKey = "pinlike-eventtype-key"
    static let creatorKey = "pinlike-creator-key"
    static let pinLikeLiveQueryNotification = Notification.Name("pinlike-livequery-notification")
    
    @NSManaged var user: User?
    @NSManaged var likedPin: Pin?
    
    static func parseClassName() -> String {
        return "PinLike"
    }
    
    static func getPinIdFromNotification(_ notification: Notification) -> String? {
        guard let pinId = notification.userInfo?[pinIdKey] as? String else {
            return nil
        }
        
        return pinId
    }
    
    static func getEventTypeFromNotification(_ notification: Notification) -> PinLikeLiveQueryEventType? {
        guard let type = notification.userInfo?[typeKey] as? PinLikeLiveQueryEventType else {
            return nil
        }
        
        return type
    }
    
    static func getCreatorIdFromNotification(_ notification: Notification) -> String? {
        guard let id = notification.userInfo?[creatorKey] as? String else {
            return nil
        }
        
        return id
    }
}
