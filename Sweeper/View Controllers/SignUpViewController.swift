//
//  SignUpViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/22/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: FancyTextField!
    @IBOutlet weak var firstNameTextField: FancyTextField!
    @IBOutlet weak var lastNameTextField: FancyTextField!
    @IBOutlet weak var passwordField: FancyTextField!
    @IBOutlet weak var confirmPasswordField: FancyTextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    lazy var requiredFields = [self.emailTextField, self.firstNameTextField, self.lastNameTextField,
                               self.passwordField, self.confirmPasswordField]
    var email: String?
    var password: String?
    
    private let missingInfo = "Did you fill all the required fields?"
    private let mismatchedPasswords = "Your passwords did not match. Please make sure they are correct"
    private let tryAgain = "Something went wrong. Try tapping sign up again."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.customize(label: "Email (never displayed publicly)*", text: email)
        firstNameTextField.customize(label: "First Name*")
        lastNameTextField.customize(label: "Last Name*")
        passwordField.customize(label: "Password*", text: password, isSecure: true)
        confirmPasswordField.customize(label: "Confirm Password*", isSecure: true)
    }
    
    @IBAction func onProfileImageTap(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: { (action) in
                self.showPicker(style: .camera)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(UIAlertAction(title: "Choose existing photo", style: .default, handler: { (action) in
                self.showPicker(style: .photoLibrary)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if alertController.actions.count > 1 {
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSignUp() {
        for field in requiredFields {
            if field!.isEmpty() {
                showError(message: missingInfo)
                return
            }
        }
        
        let password = passwordField.getExactText()
        let confirmPassword = confirmPasswordField.getExactText()
        if password != nil && password != confirmPassword {
            showError(message: mismatchedPasswords)
            return
        }
        
        let email = emailTextField.getText()
        let firstName = firstNameTextField.getText()
        let lastName = lastNameTextField.getText()
        let image = profileImageView.image == #imageLiteral(resourceName: "default_profile") ? nil : profileImageView.image
        UserService.sharedInstance.signUp(username: email, password: password!, firstName: firstName, lastName: lastName, image: image) { (error) in
            if error == nil {
                self.present(UIStoryboard.tabBarVC, animated: false, completion: nil)
            } else {
                self.showError(message: self.tryAgain)
            }
        }
    }
    
    private func showPicker(style: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = style
        present(picker, animated: true, completion: nil)
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(title: "Whoops", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImageView.image = image.compress(maxWidth: 120, maxHeight: 120)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
