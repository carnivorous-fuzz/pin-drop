//
//  StoryboardExtension.swift
//  Sweeper
//
//  Created by wuming on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

extension UIStoryboard {
    // MARK:- Storyboards
    static var tabBar: UIStoryboard {
        return getStoryboardNamed("TabBar")
    }
    
    static var main: UIStoryboard {
        return getStoryboardNamed("Main")
    }

    static var createPin: UIStoryboard {
        return getStoryboardNamed("CreatePin")
    }
    
    static var home: UIStoryboard {
        return getStoryboardNamed("Home")
    }

    static var pinDetails: UIStoryboard {
        return getStoryboardNamed("PinDetails")
    }

    static var scavengerHunt: UIStoryboard {
        return getStoryboardNamed("ScavengerHunt")
    }
    
    static var profile: UIStoryboard {
        return getStoryboardNamed("Profile")
    }
    
    static var viewedPins: UIStoryboard {
        return getStoryboardNamed("ViewedPins")
    }

    static var pinComment: UIStoryboard {
        return getStoryboardNamed("PinComment")
    }

    fileprivate static func getStoryboardNamed(_ name: String, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: bundle)
    }

    // MARK: View controllers
    static var loginVC: LoginViewController {
        return UIStoryboard.main.instantiateInitialViewController() as! LoginViewController
    }
    
    static var pinsMapVC: PinsMapViewController {
        return UIStoryboard.home.instantiateViewController(withIdentifier: "PinsMapViewController") as! PinsMapViewController
    }
    
    static var pinsListVC: PinsListViewController {
        return UIStoryboard.home.instantiateViewController(withIdentifier: "PinsListViewController") as! PinsListViewController
    }

    static var pinDetailsVC: PinDetailsViewController {
        return UIStoryboard.pinDetails.instantiateViewController(withIdentifier: "PinDetailsViewController") as! PinDetailsViewController
    }


    // MARK: Scavenger Hunt related View Controllers
    static var tagsSelectorVC: TagSelectorViewController {
        return UIStoryboard.scavengerHunt.instantiateViewController(withIdentifier: "TagSelectorViewController") as! TagSelectorViewController
    }
    
    static var tabBarVC: TabBarViewController {
        return UIStoryboard.tabBar.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
    }
    
    // MARK tab-bar Navigation controllers
    static var homeViewNC: UINavigationController {
        let controller = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
        controller.tabBarItem.title = "Home"
        controller.tabBarItem.image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: "home-selected")?.withRenderingMode(.alwaysOriginal)
        return controller
    }
    
    static var scavengerHuntNC: UINavigationController {
        let controller = UIStoryboard.scavengerHunt.instantiateViewController(withIdentifier: "ScavengerHuntNC") as! UINavigationController
        controller.tabBarItem.title = "Adventure"
        controller.tabBarItem.image = UIImage(named: "scavenger")?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: "scavenger-selected")?.withRenderingMode(.alwaysOriginal)
        return controller
    }
    
    static var createPinNC: UINavigationController {
        let controller = UIStoryboard.createPin.instantiateViewController(withIdentifier: "CreatePinNC") as! UINavigationController
        controller.tabBarItem.title = nil
        controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        controller.tabBarItem.image = UIImage(named: "create-pin")?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: "create-pin-selected")?.withRenderingMode(.alwaysOriginal)
        return controller
    }
    
    static var viewedPinsNC: UINavigationController {
        let controller = UIStoryboard.viewedPins.instantiateViewController(withIdentifier: "ViewedPinsNC") as! UINavigationController
        controller.tabBarItem.title = "Visited"
        controller.tabBarItem.title = "Visited"
        controller.tabBarItem.image = UIImage(named: "visited")?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: "visited-selected")?.withRenderingMode(.alwaysOriginal)
        return controller
    }
    
    static var profileNC: UINavigationController {
        let controller = UIStoryboard.profile.instantiateViewController(withIdentifier: "ProfileNC") as! UINavigationController
        controller.tabBarItem.title = "Profile"
        controller.tabBarItem.image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: "profile-selected")?.withRenderingMode(.alwaysOriginal)
        return controller
    }

    static var SHNavigationNC: UINavigationController {
        return UIStoryboard.scavengerHunt.instantiateViewController(withIdentifier: "SHNavigationNavViewController") as! UINavigationController
    }

    // MARK: Pin comment related controllers
    static var pinCommentNC: UINavigationController {
        return UIStoryboard.pinComment.instantiateViewController(withIdentifier: "PinCommentNavigationController") as! UINavigationController
    }

    static var pinCommentVC: PinCommentViewController {
        return UIStoryboard.pinComment.instantiateViewController(withIdentifier: "PinCommentViewController") as! PinCommentViewController
    }

}
