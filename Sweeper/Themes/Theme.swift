//
//  Theme.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    
    struct Colors {
        var green = UIColor(displayP3Red: CGFloat(19/255), green: CGFloat(91/255), blue: CGFloat(69/255), alpha: 1.0)
        var red = UIColor(displayP3Red: CGFloat(98/255), green: CGFloat(37/255), blue: CGFloat(38/255), alpha: 1.0)
        var purple = UIColor(displayP3Red: CGFloat(49/255), green: CGFloat(33/255), blue: CGFloat(95/255), alpha: 1.0)
        var lightGray = UIColor(displayP3Red: CGFloat(89/255), green: CGFloat(89/255), blue: CGFloat(89/255), alpha: 1.0)
        var darkGray = UIColor(displayP3Red: CGFloat(59/255), green: CGFloat(62/255), blue: CGFloat(67/255), alpha: 1.0)
    }
    
    struct TabBar {
        func initTabBarController(with: [UINavigationController]) -> UITabBarController {
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = with
            return tabBarController
        }
    }
    
    static func applyNavigationTheme() {
        UINavigationBar.appearance().barTintColor = Colors().green
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Colors().lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Colors().green], for: .selected)
        
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = Colors().green
    }
}
