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
    static var main: UIStoryboard {
        return getStoryboardNamed("Main")
    }

    static var createPin: UIStoryboard {
        return getStoryboardNamed("CreatePin")
    }

    static var pinViews: UIStoryboard {
        return getStoryboardNamed("PinViews")
    }

    static var viewPin: UIStoryboard {
        return getStoryboardNamed("ViewPin")
    }

    static var scavengerHunt: UIStoryboard {
        return getStoryboardNamed("ScavengerHunt")

    static var pinComment: UIStoryboard {
        return getStoryboardNamed("PinComment")
    }

    fileprivate static func getStoryboardNamed(_ name: String, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: bundle)
    }

    // MARK: View controllers
    static var pinsMapViewNC: UINavigationController {
        return UIStoryboard.pinViews.instantiateViewController(withIdentifier: "PinsMapViewNavigationController") as! UINavigationController
    }

    static var pinsListViewNC: UINavigationController {
        return UIStoryboard.pinViews.instantiateViewController(withIdentifier: "PinsListViewNavigationController") as! UINavigationController
    }

    static var loginVC: LoginViewController {
        return UIStoryboard.main.instantiateInitialViewController() as! LoginViewController
    }

    static var pinDetailsVC: PinDetailsViewController {
        return UIStoryboard.viewPin.instantiateViewController(withIdentifier: "PinDetailsViewController") as! PinDetailsViewController
    }

    static var tagsSelectorVC: TagSelectorViewController {
        return UIStoryboard.scavengerHunt.instantiateViewController(withIdentifier: "TagSelectorViewController") as! TagSelectorViewController
    }

    // MARK: Pin comment related controllers
    static var pinCommentNC: UINavigationController {
        return UIStoryboard.pinComment.instantiateViewController(withIdentifier: "PinCommentNavigationController") as! UINavigationController
    }

    static var pinCommentVC: PinCommentViewController {
        return UIStoryboard.pinComment.instantiateViewController(withIdentifier: "PinCommentViewController") as! PinCommentViewController
    }
}
