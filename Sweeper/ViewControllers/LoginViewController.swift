//
//  LoginViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/12/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
//import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameView: FancyTextField!
    @IBOutlet weak var passwordView: FancyTextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameView.fieldLabel.text = "Email"
        usernameView.textField.keyboardType = .emailAddress
        
        passwordView.textField.isSecureTextEntry = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        
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
        
        UserService.sharedInstance.signup(username: username, password: password) { (success: Bool, error: Error?) in
            if success {
                self.segueToHome()
            } else {
                self.showLoginError()
            }
        }
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
        let alertController = UIAlertController(title: "Whoops", message: "Make sure your username and email are correct", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func segueToHome() {
        present(UIStoryboard.home, animated: true, completion: nil)
    }
}
