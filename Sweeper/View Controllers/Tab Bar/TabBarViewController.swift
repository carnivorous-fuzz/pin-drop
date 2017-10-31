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
    
    // MARK: lifecycle functions
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
        didPressTab(buttons[selectedIndex])
    }
    
    // MARK: IB actions
    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedIndex
        let touchedIndex = sender.tag
        
        if previousIndex != touchedIndex {
            handleTransition(previousIndex, touchedIndex)
        }
    }
    
    // MARK: helpers
    func handleTransition(_ fromIdx: Int, _ toIdx: Int) {
        let fromViewController = viewControllers[fromIdx]
        let toViewController = viewControllers[toIdx]
        
        if isCreateTransition(toViewController) {
            // special case to handle create transition animation
            present(toViewController, animated: true, completion: nil)
        } else {
            selectedIndex = toIdx
            
            // set tab selection state/colors
            setButtonStyles(buttons[toIdx], buttons[fromIdx])
            
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
    
    func setButtonStyles (_ selectedButton: UIButton, _ deselectedButton: UIButton) {
        deselectedButton.isSelected = false
        selectedButton.isSelected = true
        
        var imageCopy = deselectedButton.currentImage
        let unselectedImage = imageCopy?.withRenderingMode(.alwaysTemplate)
        deselectedButton.setImage(unselectedImage, for: .normal)
        deselectedButton.tintColor = UIConstants.Theme.lightGray
        
        imageCopy = selectedButton.currentImage
        let selectedImage = imageCopy?.withRenderingMode(.alwaysTemplate)
        selectedButton.setImage(selectedImage, for: .selected)
        selectedButton.tintColor = UIConstants.Theme.green
    }
    
}
