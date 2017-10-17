//
//  StoryboardUtils.swift
//  Sweeper
//
//  Created by wuming on 10/17/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class StoryboardUtils {
    class func initVC(storyboard name: String, bundle: Bundle? = nil,  identifier: String) -> UIViewController {
        return UIStoryboard(name: name, bundle: bundle).instantiateViewController(withIdentifier: identifier)
    }
}
