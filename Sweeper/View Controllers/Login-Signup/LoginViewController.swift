//
//  LoginViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/12/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameView: FancyTextField!
    @IBOutlet weak var passwordView: FancyTextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var fbLoginView: UIView!
    @IBOutlet weak var fbLogoImageView: UIImageView!
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameView.fieldLabel.text = "Email"
        usernameView.textField.keyboardType = .emailAddress
        
        passwordView.textField.isSecureTextEntry = true
        
        fbLoginView.layer.cornerRadius = 7.0
        fbLoginView.clipsToBounds = true
        fbLoginView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginWithFacebook)))
        fbLogoImageView.image = #imageLiteral(resourceName: "fblogo").withRenderingMode(.alwaysTemplate)
        fbLogoImageView.tintColor = .white
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide,
                                                  object: nil)
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
    
    @IBAction func onBackgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        let username = usernameView.getText()
        let password = passwordView.getText()
        
        UserService.sharedInstance.login(username: username, password: password) { (success: Bool, error: Error?) in
            if success {
                self.segueToHome()
            } else {
                self.showLoginError()
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: UIButton) {
        let username = usernameView.getText()
        let password = passwordView.getText()
        
        let signUpVC = UIStoryboard.signUpVC
        signUpVC.email = username
        signUpVC.password = password
        show(signUpVC, sender: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        updateLayout(isKeyboardShowing: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(notificaiton: Notification) {
        updateLayout(isKeyboardShowing: false, notification: notificaiton)
    }
    
    private func updateLayout(isKeyboardShowing: Bool, notification: Notification) {
        let keyboardNotification = KeyboardNotification(notification)
        let height = keyboardNotification.frameEnd.height
        
        UIView.animate(
            withDuration: keyboardNotification.animationDuration,
            delay: 0,
            options: [keyboardNotification.animationCurve],
            animations: {
                self.bottomConstraint.constant = isKeyboardShowing ? height + 8.0 : 60.0
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
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
