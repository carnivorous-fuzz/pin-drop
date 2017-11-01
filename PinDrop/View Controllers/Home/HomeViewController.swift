//
//  HomeViewController.swift
//  PinDrop
//
//  Created by Paul Sokolik on 10/22/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    fileprivate enum ViewMode {
        case list
        case map
    }
    
    fileprivate var currentViewMode: ViewMode!
    var listViewController: UIViewController!
    var mapViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentViewMode = ViewMode.map
        
        // instantiate two view controllers we'll toggle between and set default
        listViewController = UIStoryboard.pinsListVC
        mapViewController = UIStoryboard.pinsMapVC
        handleViewTransition(nil, mapViewController, nil)
    }

    @IBAction func onToggleView(_ sender: UIBarButtonItem) {
        // toggle image
        if currentViewMode == ViewMode.map {
            handleViewTransition(mapViewController, listViewController, .flipFromRight)
            currentViewMode = ViewMode.list
            let originalImage = UIImage(named: "view-map")
            let templateImage = originalImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            sender.image = templateImage
            sender.tintColor = UIConstants.Theme.green
        } else {
            handleViewTransition(listViewController, mapViewController, .flipFromLeft)
            currentViewMode = ViewMode.map
            let originalImage = UIImage(named: "view-list")
            let templateImage = originalImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            sender.image = templateImage
            sender.tintColor = UIConstants.Theme.green
        }
    }
    
    func handleViewTransition(_ fromViewController: UIViewController?, _ toViewController: UIViewController, _ animationStyle: UIViewAnimationTransition?) {
        
        // previous view controller removal/cleanup
        if fromViewController != nil {
            fromViewController!.willMove(toParentViewController: nil)
            fromViewController!.view.removeFromSuperview()
            fromViewController!.removeFromParentViewController()
        }
        
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(0.5)
        
        // newly selected view controller
        addChildViewController(toViewController)
        toViewController.view.frame = view.bounds
        view.addSubview(toViewController.view)
        toViewController.didMove(toParentViewController: self)
        UIView.setAnimationTransition(animationStyle ?? .flipFromLeft, for: self.view, cache: false)
        UIView.commitAnimations()
    }
}
