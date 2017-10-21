//
//  SHGenerateViewController.swift
//  Sweeper
//
//  Created by Raina Wang on 10/19/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class SHGenerateViewController: UIViewController {
    @IBOutlet weak var tagsChooser: UIView!
    @IBOutlet weak var sliderVal: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Tag Chooser
        tagsChooser.slightlyRoundBorder()
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Double(sender.value).rounded(toPlaces: 1)
        sliderVal.text = "\(currentValue) mi"
    }

    @IBAction func onTagChooserTap(_ sender: UITapGestureRecognizer) {
        let tagSelectorView = UIStoryboard.tagsSelectorVC
        // TODO: make this transition look nicer
        tagSelectorView.modalPresentationStyle = UIModalPresentationStyle.formSheet
        tagSelectorView.modalTransitionStyle = UIModalTransitionStyle.partialCurl

        self.addChildViewController(tagSelectorView)
        UIView.animate(withDuration: 0.3) {
            self.view.addSubview(tagSelectorView.view)
        }
        tagSelectorView.didMove(toParentViewController: self)
    }

    @IBAction func onGenerate(_ sender: Any) {
        // TODO: loading animation
        var selectedStopCount = 1
        let selectedStopCountIndex = collectionView.indexPathsForSelectedItems

        if let selectedStopCountIndexFirst = selectedStopCountIndex?.first {
            selectedStopCount = selectedStopCountIndexFirst.row + 1
            print(selectedStopCount) // number of pins we want to generate
        }

        let sliderValue = Double(radiusSlider.value).rounded(toPlaces: 1)
        print(sliderValue)
    }
}

// MARK: UICollectionView delegate
extension SHGenerateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentControlViewCell", for: indexPath)
            as? SegmentControlViewCell {
            cell.segmentLabel.text = "\(indexPath.row + 1)"
            cell.segmentView.circleBorder()
            return cell
        }
        return SegmentControlViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SegmentControlViewCell
        cell.segmentView.backgroundColor = UIConstants.Theme.turquose
        cell.segmentLabel.textColor = UIColor.white
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SegmentControlViewCell
        cell.segmentView.backgroundColor = UIColor.white
        cell.segmentLabel.textColor = UIColor.darkGray
    }
}


