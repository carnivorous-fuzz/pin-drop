//
//  LoginViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/12/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameView: FancyTextField!
    @IBOutlet weak var passwordView: FancyTextField!
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameView.fieldLabel.text = "Email"
        passwordView.textField.isSecureTextEntry = true
    }
    
    // MARK: IBAction outlets
    @IBAction func onBackgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        let username = usernameView.getText()
        let password = passwordView.getText()
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (success, error) in
            if error == nil {
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            } else {
                self.showLoginError()
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: UIButton) {
        let user = PFUser()
        user.username = usernameView.getText()
        user.password = passwordView.getText()
        
        user.signUpInBackground(block: { (success, error) in
            if let _ = error {
                self.showLoginError()
            } else {
                // Hooray! Let them use the app now.
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        })

    }
    
    func showLoginError() {
        let alertController = UIAlertController(title: "Whoops", message: "Make sure your username and email are correct", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

//extension LoginViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.becomeFirstResponder()
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.resignFirstResponder()
//    }
//}
