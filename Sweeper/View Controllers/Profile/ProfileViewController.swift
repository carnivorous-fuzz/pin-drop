//
//  ProfileViewController.swift
//  Sweeper
//
//  Created by Paul Sokolik on 10/21/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ProfileViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pins: [Pin]!
    var user: User!
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    fileprivate var cellsPerRow: CGFloat! = 3
    
    // MARK: lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collection view setup
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CollectionViewPinCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewPinCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if user == nil {
            user = User.currentUser
        }
        
        startAnimating()
        PinService.sharedInstance.fetchPins(by: user) { (pins: [Pin]?, error: Error?) in
            self.stopAnimating()
            if error == nil {
                self.pins = pins!
                // init collection view
                self.collectionView.reloadData()
            } else {
                let button = Dialog.button(title: "Try Again", type: .plain, action: nil)
                Dialog.show(controller: self, title: "Unable to load pins", message: error?.localizedDescription ?? "Error", buttons: [button], image: nil, dismissAfter: nil, completion: nil)
            }
        }
    }
    
}

// MARK: collection view delegate
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
        if pins != nil {
            headerView.pins = pins
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pins?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewPinCell", for: indexPath) as! CollectionViewPinCell
        if pins != nil {
            cell.pin = pins[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = cellsPerRow - 1
        let availableWidth = view.frame.width - paddingSpace
        let cellWidth = availableWidth / cellsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.pinDetailsVC
        vc.pin = pins[indexPath.row]
        show(vc, sender: nil)
    }
    
}
