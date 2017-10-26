//
//  SHGenerateViewController.swift
//  Sweeper
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.gray]

        selectedTags = [Tag]()
        tagSelectionCollectionView.delegate = self
        tagSelectionCollectionView.dataSource = self
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Double(sender.value).rounded(toPlaces: 1)
        sliderVal.text = "\(currentValue) mi"
    }

    fileprivate func onTagChooserTap() {
        let tagSelectorView = UIStoryboard.tagsSelectorVC
        tagSelectorView.delegate = self

        // TODO: make this transition look nicer
        tagSelectorView.modalPresentationStyle = UIModalPresentationStyle.formSheet
        tagSelectorView.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        tagSelectorView.willMove(toParentViewController: self)
        self.addChildViewController(tagSelectorView)
        UIView.animate(withDuration: 0.3) {
            self.view.addSubview(tagSelectorView.view)
        }
        tagSelectorView.didMove(toParentViewController: self)
    }

    @IBAction func onGenerate(_ sender: Any) {
        // TODO: loading animation
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
        scavengerHunt.saveInBackground()
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
        }
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
                } else if selectedTags.count > 0 {
                    let currentTag = selectedTags[indexPath.row]
                    cell.selectedTagLabel.text = currentTag.name
                    cell.selectedTag = currentTag
                }

                cell.slightlyRoundBorder()
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
            } else {
                let cell = collectionView.cellForItem(at: indexPath) as! TagSelectedCollectionCell
                deleteTag(with: cell)
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
