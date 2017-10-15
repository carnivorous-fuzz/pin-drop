//
//  AppDelegate.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/12/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import Parse
import AWSCore
import AWSCognito
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let configuration = ParseClientConfiguration {
            $0.applicationId = "com.team11.Sweeper"
            $0.server = "http://165.227.6.232:1337/parse"
            $0.isLocalDatastoreEnabled = true
        }
        
        Parse.initialize(with: configuration)

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId:"us-east-1:39325d1c-04a9-4b41-8a5c-17a7e8dc7ced")
        let awsConfiguration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = awsConfiguration
        
        User.getStoredUser(completion: { (user: User?) in
            if user != nil {
                let storyboard = UIStoryboard(name: "Pinviews", bundle: nil)
                let navigationVC = storyboard.instantiateViewController(withIdentifier: "PinviewsNavigationController")
                
                self.window?.rootViewController = navigationVC
            } else {
                print("user not found in local data store")
            }
        })
        
        GMSServices.provideAPIKey("AIzaSyA9pJAN_2kseox1wiaUUiEZYM-9ffMkXTs")
        GMSPlacesClient.provideAPIKey("AIzaSyA9pJAN_2kseox1wiaUUiEZYM-9ffMkXTs")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

