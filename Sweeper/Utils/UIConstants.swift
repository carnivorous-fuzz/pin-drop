//
//  UIConstants.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(fromHex rgb: Int) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8)/255.0,
                  blue: CGFloat((rgb & 0x0000FF))/255.0,
                  alpha: 1.0)
    }
}

struct UIConstants {
    
    struct Theme {
        static let highlightBlue = UIColor(red: 0.24, green: 0.76, blue: 0.93, alpha: 1.0)
        static let mediumGray = UIColor(red: 0.70, green: 0.70, blue: 0.70, alpha: 1.0)
        static let turquose = UIColor(fromHex: 0x65EDC4)
        static let titleBlack = UIColor(fromHex: 0x47525E)
        static let green = UIColor(red: CGFloat(48)/255, green: CGFloat(231)/255, blue: CGFloat(176)/255, alpha: 1.0)
        static let red = UIColor(red: CGFloat(249)/255, green: CGFloat(95)/255, blue: CGFloat(98)/255, alpha: 1.0)
        static let purple = UIColor(red: CGFloat(126)/255, green: CGFloat(85)/255, blue: CGFloat(243)/255, alpha: 1.0)
        static let lightGray = UIColor(red: CGFloat(226)/255, green: CGFloat(226)/255, blue: CGFloat(226)/255, alpha: 1.0)
        static let darkGray = UIColor(red: CGFloat(150)/255, green: CGFloat(159)/255, blue: CGFloat(170)/255, alpha: 1.0)
        
        static func applyNavigationTheme() {
            UINavigationBar.appearance().barTintColor = Theme.green
            UINavigationBar.appearance().tintColor = UIColor.white
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
}
