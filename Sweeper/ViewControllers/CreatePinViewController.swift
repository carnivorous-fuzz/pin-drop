//
//  CreatePinViewController.swift
//  Sweeper
//
//  Created by Raina Wang on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import CoreLocation
import KMPlaceholderTextView

class CreatePinViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var locationBanner: LocationBanner!
    @IBOutlet weak var titleField: FancyTextField!
    @IBOutlet weak var tagsField: FancyTextField!
    @IBOutlet weak var messageTextView: KMPlaceholderTextView!
    @IBOutlet weak var importedImageView: UIImageView!
    
    fileprivate var currentLocation: CLLocation?
    fileprivate var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        titleField.fieldLabel.text = "Title"
        tagsField.fieldLabel.text = "Tags"
    }
    private func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }
    @IBAction func onPost(_ sender: Any) {
        
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
            // TODO: should do some animation for uploading the image
            self.importedImageView.image = image
        } else {
            print("No image was selected")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
