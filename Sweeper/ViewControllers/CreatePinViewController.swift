//
//  CreatePinViewController.swift
//  Sweeper
//
//  Created by Raina Wang on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
import KMPlaceholderTextView
import Parse

class CreatePinViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var locationBanner: LocationBanner!
    @IBOutlet weak var titleField: FancyTextField!
    @IBOutlet weak var tagsField: FancyTextField!
    @IBOutlet weak var messageTextView: KMPlaceholderTextView!
    @IBOutlet weak var importedImageView: UIImageView!
    @IBOutlet weak var editingView: UIView!
    
    fileprivate var currentLocation: CLLocation?
    fileprivate var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        createDismissBarItem()
        getLocation()
        titleField.fieldLabel.text = "Add a Title"
        tagsField.fieldLabel.text = "Add Tags"
        editingView.layer.borderWidth = 1
        editingView.layer.cornerRadius = 10
        editingView.layer.borderColor = UIConstants.Theme.mediumGray.cgColor
        editingView.dropShadow(color: UIConstants.Theme.mediumGray, offSet: CGSize(width: -1, height: 1), radius: 2)
        importedImageView.layer.cornerRadius = 20
    }
    
    private func createDismissBarItem() {
        guard let count = navigationController?.viewControllers.count else {
            return
        }
        
        if count > 1 {
            return
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: .plain, target: self, action: #selector(onCancel))
    }
    
    private func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func onPost(_ sender: Any) {
        let tags = tagsField.getText()
        let tagNames = tags.components(separatedBy: ",")

        let pin = Pin()
        pin.blurb = titleField.getText()
        pin.latitude = currentLocation?.coordinate.latitude
        pin.longitude = currentLocation?.coordinate.longitude
        pin.setLocation()
        pin.message = messageTextView.text

        // TODO: animation while waiting for the image saving
        PinService.sharedInstance.create(pin: pin, withImage: importedImageView.image ?? nil, tagNames: tagNames) { (success: Bool, error: Error?) in
            if success {
                print("saved!")
                print(pin.blurb!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func importImage(_ sender: Any) {
        let alertController = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showPicker(with: UIImagePickerControllerSourceType.camera)
        }))
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.showPicker(with: UIImagePickerControllerSourceType.photoLibrary)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func onCancel() {
        dismiss(animated: true, completion: nil)
    }

    fileprivate func showPicker(with type: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = type
            image.allowsEditing = false
            self.present(image, animated: true)
        } else {
            print("Media type is not supported")
        }
    }
}

// MARK: Location manager delegate
extension CreatePinViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            locationBanner.prepare(with: self.currentLocation!)
        }
    }
}

// MARK: Image Picker delegate
extension CreatePinViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.importedImageView.image = image.compress()
            // TODO: should do some animation for uploading the image
        } else {
            print("No image was selected")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
