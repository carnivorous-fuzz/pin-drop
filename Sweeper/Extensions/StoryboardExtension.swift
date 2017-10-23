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
    static var loginVC: UINavigationController {
        return UIStoryboard.main.instantiateInitialViewController() as! UINavigationController
    }

    static var signUpVC: SignUpViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
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
        return UIStoryboard.home.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
    }

    static var scavengerHuntNC: UINavigationController {
        return UIStoryboard.scavengerHunt.instantiateViewController(withIdentifier: "ScavengerHuntNC") as! UINavigationController
    }

    static var createPinNC: UINavigationController {
        return UIStoryboard.createPin.instantiateViewController(withIdentifier: "CreatePinNC") as! UINavigationController
    }

    static var viewedPinsNC: UINavigationController {
        return UIStoryboard.viewedPins.instantiateViewController(withIdentifier: "ViewedPinsNC") as! UINavigationController
    }

    static var profileNC: UINavigationController {
        return UIStoryboard.profile.instantiateViewController(withIdentifier: "ProfileNC") as! UINavigationController
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
