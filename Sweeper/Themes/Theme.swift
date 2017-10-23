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
        var green = UIColor(displayP3Red: CGFloat(48)/255, green: CGFloat(231)/255, blue: CGFloat(176)/255, alpha: 1.0)
        var red = UIColor(displayP3Red: CGFloat(249)/255, green: CGFloat(95)/255, blue: CGFloat(98)/255, alpha: 1.0)
        var purple = UIColor(displayP3Red: CGFloat(126)/255, green: CGFloat(85)/255, blue: CGFloat(243)/255, alpha: 1.0)
        var lightGray = UIColor(displayP3Red: CGFloat(226)/255, green: CGFloat(226)/255, blue: CGFloat(226)/255, alpha: 1.0)
        var darkGray = UIColor(displayP3Red: CGFloat(150)/255, green: CGFloat(159)/255, blue: CGFloat(170)/255, alpha: 1.0)
    }
    
    static func applyNavigationTheme() {
        UINavigationBar.appearance().barTintColor = Colors().green
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
