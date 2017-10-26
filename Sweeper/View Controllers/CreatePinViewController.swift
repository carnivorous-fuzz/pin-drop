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
import Fusuma

class CreatePinViewController: UIViewController, UINavigationControllerDelegate {
//    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var locationBanner: LocationBanner!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var messageTextView: KMPlaceholderTextView!
    @IBOutlet weak var importedImageView: UIImageView!
    @IBOutlet weak var editingView: UIView!
    
    fileprivate var currentLocation: CLLocation?
    fileprivate var locationManager: CLLocationManager!
    fileprivate var fusuma = FusumaViewController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true

        fusuma.delegate = self
        addChildViewController(fusuma)
        fusuma.view.frame = view.bounds
        view.addSubview(fusuma.view)
        fusuma.didMove(toParentViewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.borderStyle = UITextBorderStyle.none

        let user = User.current()
        if let url = user?.getImageUrl() {
            profileImage.setImageWith(url)
            profileImage.layer.cornerRadius = 20
        }

        createDismissBarItem()
        getLocation()
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
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func onPost(_ sender: Any) {
//        let tags = tagsField.getText()
//        let tagNames = tags.components(separatedBy: ",")

//        let pin = Pin()
//        pin.blurb = titleField.getText()
//        pin.latitude = currentLocation?.coordinate.latitude
//        pin.longitude = currentLocation?.coordinate.longitude
//        pin.setLocation()
//        pin.message = messageTextView.text
//
//        // TODO: animation while waiting for the image saving
//        PinService.sharedInstance.create(pin: pin, withImage: importedImageView.image ?? nil, tagNames: tagNames) { (success: Bool, error: Error?) in
//            if success {
//                print("saved!")
//                print(pin.blurb!)
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    @objc func onCancel() {
        dismiss(animated: true, completion: nil)
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

// MARK: Fusuma delegate
extension CreatePinViewController: FusumaDelegate {
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        fusuma.willMove(toParentViewController: nil)
        fusuma.view.removeFromSuperview()
        fusuma.removeFromParentViewController()

        self.navigationController?.navigationBar.isHidden = false
        importedImageView.image = image
        importedImageView.layer.cornerRadius = 20
        titleField.becomeFirstResponder()
    }
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {
        print("Called just after FusumaViewController is dismissed.")
    }

    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
    }
}
