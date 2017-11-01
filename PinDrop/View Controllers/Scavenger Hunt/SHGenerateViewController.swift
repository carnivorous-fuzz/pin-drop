//
//  SHGenerateViewController.swift
//  PinDrop
//
//  Created by Raina Wang on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import CoreLocation

class SHGenerateViewController: UIViewController {
    @IBOutlet weak var sliderVal: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var stopsCollectionView: UICollectionView!
    @IBOutlet weak var tagSelectionCollectionView: UICollectionView!

    fileprivate var scavengerHunt: ScavengerHunt?
    fileprivate var currentLocation: CLLocation?
    fileprivate var locationManager: CLLocationManager!

    fileprivate let maxTagOrStops = 5
    fileprivate var selectedTagCount: Int!
    fileprivate var selectedTags: [Tag]! {
        didSet {
            selectedTagCount = self.selectedTags.count
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIConstants.Theme.green

        selectedTags = [Tag]()
        tagSelectionCollectionView.delegate = self
        tagSelectionCollectionView.dataSource = self

        getLocation()
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Double(sender.value).rounded(toPlaces: 1)
        sliderVal.text = "\(currentValue) mi"
    }

    fileprivate func onTagChooserTap() {
        let tagSelectorNC = UIStoryboard.tagsSelectorNC
        let tagSelectorVC = tagSelectorNC.topViewController as! TagSelectorViewController
        tagSelectorVC.delegate = self
        present(tagSelectorNC, animated: true, completion: nil)
    }

    @IBAction func onGenerate(_ sender: Any) {
        // TODO: Improve pin filter based on count
        var selectedStopCount = 1
        let selectedStopCountIndex = stopsCollectionView.indexPathsForSelectedItems

        if let selectedStopCountIndexFirst = selectedStopCountIndex?.first {
            selectedStopCount = selectedStopCountIndexFirst.row + 1
        }

        let sliderValue = Double(radiusSlider.value).rounded(toPlaces: 1)

        let scavengerHunt = ScavengerHunt()
        scavengerHunt.pinCount = selectedStopCount as NSNumber
        scavengerHunt.radius = sliderValue as NSNumber
        scavengerHunt.user = User.currentUser
        scavengerHunt.selectedTags = selectedTags
        self.scavengerHunt = scavengerHunt
        self.performSegue(withIdentifier: "SHNavigationSegue", sender: self)
    }

    fileprivate func deleteTag(with selectedCell: TagSelectedCollectionCell) {
        UIView.animate(withDuration: 1) {
            if let index = self.selectedTags.index(of: selectedCell.selectedTag) {
                self.selectedTags.remove(at: index)
                self.tagSelectionCollectionView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "SHNavigationSegue" {
            let destination = segue.destination as! UINavigationController
            let SHNavVC = destination.topViewController as! SHNavigationViewController
            SHNavVC.scavengerHunt = self.scavengerHunt
            SHNavVC.currentLocation = self.currentLocation
        }
	}
}
// MARK: Location manager delegate
extension SHGenerateViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
        } else {
            let cancel = Dialog.button(title: "ok", type: .cancel, action: nil)
            Dialog.show(controller: self, title: "Unable to get your location", message: "Please check your location privacy", buttons: [cancel], image: nil, dismissAfter: nil, completion: nil)
        }
    }

    fileprivate func getLocation() {
        locationManager = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }
}

// MARK: UICollectionView delegate
extension SHGenerateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == stopsCollectionView {
            return maxTagOrStops
        } else {
            return selectedTagCount == maxTagOrStops ? selectedTagCount : selectedTagCount + 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == stopsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentControlViewCell", for: indexPath)
                as? SegmentControlViewCell {
                cell.segmentLabel.text = "\(indexPath.row + 1)"
                cell.segmentView.circleBorder()
                return cell
            }
            return SegmentControlViewCell()
        } else if collectionView == tagSelectionCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagSelectedCollectionCell", for: indexPath)
                as? TagSelectedCollectionCell
            {
                if (indexPath.row == selectedTagCount) && (selectedTagCount < maxTagOrStops)  {
                    cell.selectedTagLabel.text = "Add"
                    cell.removeButton.isHidden = true
                } else if selectedTags.count > 0 {
                    let currentTag = selectedTags[indexPath.row]
                    cell.delegate = self
                    cell.selectedTagLabel.text = currentTag.name
                    cell.selectedTag = currentTag
                    cell.removeButton.isHidden = false
                }

                return cell
            }
            return TagSelectedCollectionCell()
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == stopsCollectionView) {
            let cell = collectionView.cellForItem(at: indexPath) as! SegmentControlViewCell
            cell.segmentView.backgroundColor = UIConstants.Theme.turquose
            cell.segmentLabel.textColor = UIColor.white
        } else {
            if (indexPath.row == selectedTagCount) && (selectedTagCount < maxTagOrStops)  {
                onTagChooserTap()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if (collectionView == stopsCollectionView) {
            let cell = collectionView.cellForItem(at: indexPath) as! SegmentControlViewCell
            cell.segmentView.backgroundColor = UIColor.white
            cell.segmentLabel.textColor = UIColor.darkGray
        }
    }
}

// MARK: tag selector view controller delegate
extension SHGenerateViewController: TagSelectorViewControllerDelegate {
    func tagSelected(tagSelectorViewController: TagSelectorViewController, didSelectTag tag: Tag?) {
        if (tag != nil) && (self.selectedTags.count < maxTagOrStops) {
            self.selectedTags.append(tag!)
            tagSelectionCollectionView.reloadData()
        }
    }
}

// MARK: tag selected collection cell delegate
extension SHGenerateViewController: TagSelectedCollectionCellDelegate {
    func removeTag(tagSelectedCollectionCell: TagSelectedCollectionCell, didRemoveTag tag: Tag) {
        if let index = selectedTags.index(of: tag) {
            selectedTags.remove(at: index)
            tagSelectionCollectionView.reloadData()
        } else {
            let button = Dialog.button(title: "ok", type: .cancel, action: nil)
            Dialog.show(controller: self, title: "Unable to remove tag", message: "Please try again", buttons: [button], image: nil, dismissAfter: nil, completion: nil)
        }
    }
}
