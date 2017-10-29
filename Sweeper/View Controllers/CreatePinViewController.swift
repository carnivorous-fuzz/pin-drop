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
import NVActivityIndicatorView

class CreatePinViewController: UIViewController, UINavigationControllerDelegate, NVActivityIndicatorViewable {
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var locationBanner: LocationBanner!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var messageTextView: KMPlaceholderTextView!
    @IBOutlet weak var importedImageView: UIImageView!
    @IBOutlet weak var editingView: UIView!
    @IBOutlet weak var tagsView: UIView!
    @IBOutlet weak var addTagButton: UIButton!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var tagTextView: UITextField!
    @IBOutlet weak var tagsViewTop: NSLayoutConstraint!

    fileprivate var currentLocation: CLLocation?
    fileprivate var locationManager: CLLocationManager!
    fileprivate var fusuma: FusumaViewController!
    fileprivate var tags = [String]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showImagePicker()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        messageTextView.delegate = self
        tagTextView.delegate = self
        titleField.borderStyle = UITextBorderStyle.none
        tagTextView.borderStyle = UITextBorderStyle.none

        let user = User.current()
        if let url = user?.getImageUrl() {
            profileImage.setImageWith(url)
            profileImage.layer.cornerRadius = 20
            profileImage.layer.masksToBounds = true
        }

        addTagButton.layer.cornerRadius = 10
        addTagButton.layer.masksToBounds = true

        createDismissBarItem()
        getLocation()
    }

    fileprivate func showImagePicker() {
        self.navigationController?.navigationBar.isHidden = true
        fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.defaultMode = .camera
        updateActiveVC(activeVC: fusuma, parentView: view)
    }

    fileprivate func hideImagePicker() {
        self.navigationController?.navigationBar.isHidden = false
        removeInactiveVC(inactiveVC: fusuma)
    }

    fileprivate func updateActiveVC(activeVC: UIViewController, parentView: UIView) {
        addChildViewController(activeVC)
        activeVC.willMove(toParentViewController: self)
        activeVC.view.frame = parentView.bounds
        activeVC.view.frame.origin.y = activeVC.view.frame.origin.y + 10
        activeVC.view.frame.size.height = parentView.frame.height - 10
        parentView.addSubview(activeVC.view)
        activeVC.didMove(toParentViewController: self)
    }
    fileprivate func removeInactiveVC(inactiveVC: UIViewController?) {
        inactiveVC?.willMove(toParentViewController: nil)
        inactiveVC?.view.removeFromSuperview()
        inactiveVC?.removeFromParentViewController()
        inactiveVC?.didMove(toParentViewController: nil)
    }

    fileprivate func blackOut() {
        UIView.animate(withDuration: 0.3) {
            self.maskView.backgroundColor = UIColor.black
            self.view.bringSubview(toFront: self.maskView)
            self.view.bringSubview(toFront: self.editingView)
        }
    }

    fileprivate func deBlackOut() {
        UIView.animate(withDuration: 0.3) {
            self.maskView.backgroundColor = UIColor.clear
            self.view.sendSubview(toBack: self.editingView)
            self.view.sendSubview(toBack: self.maskView)
        }
    }

    fileprivate func tagsViewSlideUp() {
        tagsViewTop.constant = 71
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    fileprivate func tagsViewSlideDown() {
        tagsViewTop.constant = 252
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
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
    
    fileprivate func getLocation() {
        locationManager = CLLocationManager()
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }
    @IBAction func onImportedImageTap(_ sender: UITapGestureRecognizer) {
        showImagePicker()
    }
    
    @IBAction func onAddTag(_ sender: Any) {
        if (tagTextView.text != nil) && !tagTextView.text!.isEmpty {
            tags.append(tagTextView.text!)
            tagTextView.text = ""
            UIView.animate(withDuration: 0.3) {
                self.tagsCollectionView.reloadData()
            }
        }
    }

    @IBAction func onPost(_ sender: Any) {
        startAnimating()
        let pin = Pin()
        pin.blurb = titleField.text
        pin.latitude = currentLocation?.coordinate.latitude
        pin.longitude = currentLocation?.coordinate.longitude
        pin.setLocation()
        pin.locationName = locationBanner.addressLabel.text
        pin.message = messageTextView.text

        PinService.sharedInstance.create(pin: pin, withImage: importedImageView.image ?? nil, tagNames: self.tags) { (success: Bool, error: Error?) in
            if success {
                self.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            } else {
                let button = Dialog.button(title: "Try Again", type: .plain, action: nil)
                Dialog.show(controller: self, title: "Post pin failed", message: error!.localizedDescription, buttons: [button], image: nil, dismissAfter: nil, completion: nil)
            }
        }
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
        // Mandatory delegte conform method
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        // Mandatory delegte conform method
    }
    
    func fusumaCameraRollUnauthorized() {
        let button = Dialog.button(title: "ok", type: .cancel, action: nil)
        Dialog.show(controller: self, title: "Unable to open camera", message: "Check you camera and library permission", buttons: [button], image: nil, dismissAfter: nil, completion: nil)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        hideImagePicker()

        importedImageView.image = image.compress()
        importedImageView.layer.cornerRadius = 20
        importedImageView.layer.masksToBounds = true
        titleField.becomeFirstResponder()
    }
}

// MARK: text view delegate
extension CreatePinViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        blackOut()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        deBlackOut()
    }
}

// MARK: text feild delegate
extension CreatePinViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tagTextView {
            tagsViewSlideUp()
        } else {
            blackOut()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tagTextView {
            tagsViewSlideDown()
        } else {
            deBlackOut()
        }
    }
}

// MARK: collection view delegate
extension CreatePinViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddTagCollectionViewCell", for: indexPath)
            as? AddTagCollectionViewCell
        {
            cell.tagLabel.text = tags[indexPath.row]
            cell.delegate = self
            return cell
        }
        return AddTagCollectionViewCell()
    }
}

// MARK: tag collection cell delegate
extension CreatePinViewController: AddTagCollectionViewCellDelegate {
    func removeTag(addTagCollectionViewCell: AddTagCollectionViewCell, didRemoveTag tag: String) {
        if let index = tags.index(of: tag) {
            tags.remove(at: index)
            tagsCollectionView.reloadData()
        } else {
            let button = Dialog.button(title: "ok", type: .cancel, action: nil)
            Dialog.show(controller: self, title: "Unable to remove tag", message: "Please try again", buttons: [button], image: nil, dismissAfter: nil, completion: nil)
        }
    }
}
