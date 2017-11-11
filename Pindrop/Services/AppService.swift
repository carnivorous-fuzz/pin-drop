//
//  AppService.swift
//  Pindrop
//
//  Created by Paul Sokolik on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CoreLocation
import Parse
import ParseLiveQuery

class AppService {
    static let sharedInstance = AppService()
    
    let client: Client = Client.shared
    
    // MARK: PinLike live query properties
    private let pinLikeQuery = PinLike.query()!.whereKeyExists("user").order(byAscending: "createdAt") as! PFQuery<PinLike>
    private var pinLikeSubscription: Subscription<PinLike>?
    private lazy var pinLikeSubscriptionCreator = { () -> Subscription<PinLike> in
        let subscription = self.client.subscribe(self.pinLikeQuery).handleEvent({ (query, event) in
            switch event {
            case .created(let pinLike):
                self.pinLikeLiveQueryHandler(pinLike, type: .like)
            case .deleted(let pinLike):
                self.pinLikeLiveQueryHandler(pinLike, type: .unlike)
            default:
                break
            }
        })
        return subscription
    }
    
    // MARK: Pin live query properties
    private let pinQuery = Pin.query()!.whereKeyExists("creator").order(byAscending: "createdAt") as! PFQuery<Pin>
    private var pinSubscription: Subscription<Pin>?
    private lazy var pinSubscriptionCreator = { () -> Subscription<Pin> in
        let subscription = self.client.subscribe(self.pinQuery).handle(Event.created, { (query, pin) in
            self.pinCreateLiveQueryHandler(pin)
        })
        return subscription
    }
    
    private init() {}
    
    func subscribeToPinLikeUpdates() {
        if pinLikeSubscription == nil {
            pinLikeSubscription = pinLikeSubscriptionCreator()
        }
    }
    
    func unsubscribePinLikeUpdates() {
        if pinLikeSubscription != nil {
            client.unsubscribe(pinLikeQuery as! PFQuery<PFObject>)
            pinLikeSubscription = nil
        }
    }
    
    func subscribeToPinCreation() {
        if pinSubscription == nil {
            pinSubscription = pinSubscriptionCreator()
        }
    }
    
    func unsubscribeToPinCreation() {
        if pinSubscription != nil {
            client.unsubscribe(pinQuery as! PFQuery<PFObject>)
            pinSubscription = nil
        }
    }
    
    func requestLocalNotificationsPermissions(deniedHandler: (() -> ())?) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if !granted {
                deniedHandler?()
            }
        }
    }
    
    func removeNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func addLocalNotification(forPin pin: Pin) {
        if pin.location == nil || pin.creator?.objectId == User.currentUser?.objectId {
            return
        }
        
        let location = Location.geoPointToCoordinate(pin.location!)
        print(location)
        let trigger = UNLocationNotificationTrigger(
            region: CLCircularRegion(center: location, radius: 200, identifier: "\(pin.objectId!)\(location)"),
            repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "You're near a pin!"
        content.body = "\(pin.creator?.getFullName() ?? "Someone") left a pin nearby"
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest(identifier: pin.objectId!, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func pinLikeLiveQueryHandler(_ pinLike: PinLike, type: PinLikeLiveQueryEventType) {
        if let likedPinId = pinLike.likedPin?.objectId {
            let info: [AnyHashable: Any] = [
                PinLike.pinIdKey: likedPinId,
                PinLike.typeKey: type,
                PinLike.creatorKey: pinLike.user!.objectId!
            ]
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: PinLike.pinLikeLiveQueryNotification,
                                                object: nil,
                                                userInfo: info)
            }
        }
    }
    
    private func pinCreateLiveQueryHandler(_ pin: Pin) {
        do {
            try pin.creator?.fetchIfNeeded()
            addLocalNotification(forPin: pin)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Pin.pinLiveQueryNotification,
                                                object: nil,
                                                userInfo: [Pin.pinKey: pin])
            }
        } catch {
            // Not safe to add pin to app
        }
    }
}
