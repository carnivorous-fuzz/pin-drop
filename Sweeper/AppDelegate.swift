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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Parse config
        let configuration = ParseClientConfiguration {
            $0.applicationId = "com.team11.Sweeper"
            $0.server = "http://165.227.6.232:1337/parse"
            $0.isLocalDatastoreEnabled = true
        }
        Parse.initialize(with: configuration)

        // AWS S3 config
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId:"us-east-1:39325d1c-04a9-4b41-8a5c-17a7e8dc7ced")
        let awsConfiguration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = awsConfiguration
        
        // apply global themes
        Theme.applyNavigationTheme()
        let homeNC = UIStoryboard.homeViewNC
        let scavengerHuntNC = UIStoryboard.scavengerHuntNC
        let createPinNC = UIStoryboard.createPinNC
        let viewedPinsNC = UIStoryboard.viewedPinsNC
        let profileNC = UIStoryboard.profileNC
        let controllers = [homeNC, scavengerHuntNC, createPinNC, viewedPinsNC, profileNC]
        let tabBarController = Theme.TabBar().initTabBarController(with: controllers)
        //window?.makeKeyAndVisible()
        
        // init starting view
        if User.currentUser != nil {
            window?.rootViewController = tabBarController
        }
        
        // listeners
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: User.userDidLogoutKey),
            object: nil,
            queue: OperationQueue.main) { _ in
                self.window?.rootViewController = UIStoryboard.loginVC
        }

        return true
    }
}

