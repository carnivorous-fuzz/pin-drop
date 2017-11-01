//
//  LoginViewController.swift
//  Pindrop
//
//  Created by Wuming Xie on 10/12/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    // MARK: outlets
    @IBOutlet weak var introScrollView: UIScrollView!
    @IBOutlet weak var introPageControl: UIPageControl!
    @IBOutlet weak var fbLoginView: UIView!
    @IBOutlet weak var fbLogoImageView: UIImageView!
    
    // MARK: controller variables
    private var pages = 4
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginView.layer.cornerRadius = 7.0
        fbLoginView.clipsToBounds = true
        fbLoginView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithFacebook)))
        fbLogoImageView.image = #imageLiteral(resourceName: "fblogo").withRenderingMode(.alwaysTemplate)
        fbLogoImageView.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let pageWidth = introScrollView.bounds.width
        let pageHeight = introScrollView.bounds.height
        introScrollView.delegate = self
        introScrollView.contentSize = CGSize(width: pageWidth * CGFloat(pages), height: pageHeight)
        introScrollView.isPagingEnabled = true
        introPageControl.numberOfPages = pages
        
        let view1 = WelcomeView(frame: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        view1.welcomeLabel.text = "Welcome!"
        view1.welcomeImageView.image = #imageLiteral(resourceName: "pin_drop_logo").withRenderingMode(.alwaysTemplate)
        view1.welcomeImageView.tintColor = UIConstants.Theme.turquose
        let view2 = WelcomeView(frame: CGRect(x: pageWidth, y: 0, width: pageWidth, height: pageHeight))
        view2.welcomeLabel.text = "View pins around your location."
        view2.welcomeImageView.image = #imageLiteral(resourceName: "preview1")
        let view3 = WelcomeView(frame: CGRect(x: 2.0 * pageWidth, y: 0, width: pageWidth, height: pageHeight))
        view3.welcomeLabel.text = "See all the pins you've created."
        view3.welcomeImageView.image = #imageLiteral(resourceName: "preview2")
        let view4 = WelcomeView(frame: CGRect(x: 3.0 * pageWidth, y: 0, width: pageWidth, height: pageHeight))
        view4.welcomeLabel.text = "Get notified when you're close to a pin!"
        view4.welcomeImageView.image = #imageLiteral(resourceName: "preview3")
        
        introScrollView.addSubview(view1)
        introScrollView.addSubview(view2)
        introScrollView.addSubview(view3)
        introScrollView.addSubview(view4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: IBAction outlets
    @IBAction func loginWithFacebook(_ sender: UITapGestureRecognizer) {
        UserService.sharedInstance.loginWithFacebook { (user, error) in
            if let user = user {
                User.currentUser = user
                DispatchQueue.main.async {
                    self.segueToHome()
                }
            }
        }
    }
    
    @IBAction func pageDidChange(_ sender: UIPageControl) {
        let xOffSet = introScrollView.bounds.width * CGFloat(sender.currentPage)
        introScrollView.setContentOffset(CGPoint(x: xOffSet, y: 0), animated: true)
    }
    
    // MARK: Helpers
    private func showLoginError() {
        let cancelButton = Dialog.button(title: "Dismiss", type: .cancel, action: nil)
        Dialog.show(controller: self, title: "Login Error", message: "Make sure your username and email are correct", buttons: [cancelButton], image: nil, dismissAfter: nil, completion: nil)
    }
    
    private func segueToHome() {
        if UIApplication.shared.keyWindow?.rootViewController != nil {
            UIApplication.shared.keyWindow!.rootViewController = UIStoryboard.tabBarVC
        } else {
            present(UIStoryboard.tabBarVC, animated: true, completion: nil)
        }
    }
}

// MARK: ScrollView delegate handler
extension LoginViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / view.bounds.width))
        
        introPageControl.currentPage = page
    }
}
