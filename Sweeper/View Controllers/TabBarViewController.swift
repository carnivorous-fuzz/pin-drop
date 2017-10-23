//
//  TabBarViewController.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/22/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {
    // MARK: outlets
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: class variables
    var homeViewController: UINavigationController!
    var scavengerHuntViewController: UINavigationController!
    var createPinViewController: UINavigationController!
    var visitedPinsViewController: UINavigationController!
    var profileViewController: UINavigationController!
    var viewControllers: [UINavigationController]!
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // instantiate each view controller
        homeViewController = UIStoryboard.homeViewNC
        scavengerHuntViewController = UIStoryboard.scavengerHuntNC
        createPinViewController = UIStoryboard.createPinNC
        visitedPinsViewController = UIStoryboard.viewedPinsNC
        profileViewController = UIStoryboard.profileNC
        
        viewControllers = [
            homeViewController,
            scavengerHuntViewController,
            createPinViewController,
            visitedPinsViewController,
            profileViewController
        ]

        // init selected vc
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        buttons[previousIndex].isSelected = false
        sender.isSelected = true
        
        let previousVC = viewControllers[previousIndex]
        let newVC = viewControllers[selectedIndex]
        handleTransition(previousVC, newVC)
        
        
    }
    
    func handleTransition(_ fromViewController: UINavigationController, _ toViewController: UINavigationController) {
        
        if isCreateTransition(toViewController) {
            // special case to handle create transition animation
            present(toViewController, animated: true, completion: nil)
        } else {
            // previous view controller removal/cleanup
            fromViewController.willMove(toParentViewController: nil)
            fromViewController.view.removeFromSuperview()
            fromViewController.removeFromParentViewController()
            
            // newly selected view controller
            addChildViewController(toViewController)
            toViewController.view.frame = contentView.bounds
            contentView.addSubview(toViewController.view)
            toViewController.didMove(toParentViewController: self)
        }
        
    }
    
    func isCreateTransition (_ toViewController: UINavigationController) -> Bool {
        if let _ = toViewController.topViewController as? CreatePinViewController {
            return true
        }
        
        return false
    }
    
}
