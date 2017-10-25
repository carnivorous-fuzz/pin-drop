//
//  EditProfileViewController.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/22/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    fileprivate var user: User! = User.currentUser
    fileprivate var isDirty: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.backgroundColor = UIConstants.Theme.green
        saveButton.layer.cornerRadius = 7
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIConstants.Theme.lightGray.cgColor
        saveButton.isEnabled = false
        
        if let imageUrl = user.getImageUrl() {
            profileImageView.setImageWith(imageUrl)
        } else {
            profileImageView.image = UIImage(named: "default_profile")
        }
        firstNameTextField.text = user.firstName ?? ""
        lastNameTextField.text = user.lastName ?? ""
        usernameTextField.text = user.username ?? ""
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard () {
        view.endEditing(true)
    }
    
    @IBAction func onChooseImage(_ sender: UIButton) {
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
    
    @IBAction func onChangeTextField(_ sender: UITextField) {
        isDirty = true
        saveButton.isEnabled = true
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        user.firstName = firstNameTextField.text
        user.lastName = lastNameTextField.text
        user.username = usernameTextField.text
        print("touched save")
        saveButton.isEnabled = false
        //TODO: password updates, image updates
        
        user.saveInBackground { (success: Bool, error: Error?) in
            if success {
                self.navigationController?.popViewController(animated: true)
                print("User saved!")
            } else {
                print("error: \(error!.localizedDescription)")
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
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImageView.image = image.compress(maxWidth: 120, maxHeight: 120)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
