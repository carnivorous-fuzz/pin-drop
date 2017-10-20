//
//  StoryboardExtension.swift
//  Sweeper
//
//  Created by wuming on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

extension UIStoryboard {
    // MARK: Storyboards
    static var main: UIStoryboard {
        return getStoryboardNamed("Main")
    }
    
    static var createPin: UIStoryboard {
        return getStoryboardNamed("CreatePin")
    }
    
    static var pinViews: UIStoryboard {
        return getStoryboardNamed("Pinviews")
    }
    
    static var viewPin: UIStoryboard {
        return getStoryboardNamed("ViewPin")
    }
    
    fileprivate static func getStoryboardNamed(_ name: String, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    // MARK: View controllers
    static var pinViewsNC: UINavigationController {
        return UIStoryboard.pinViews.instantiateViewController(withIdentifier: "PinviewsNavigationController") as! UINavigationController
    }
    
    static var loginVC: LoginViewController {
        return UIStoryboard.main.instantiateInitialViewController() as! LoginViewController
    }
    
    static var pinDetailsVC: PinDetailsViewController {
        return UIStoryboard.viewPin.instantiateViewController(withIdentifier: "PinDetailsViewController") as! PinDetailsViewController
    }
}
