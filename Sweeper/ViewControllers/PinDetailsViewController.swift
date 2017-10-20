//
//  PinViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class PinDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var pinCard: PinDetailsCard!
    @IBOutlet weak var pinCardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var pinAnnotation: PinAnnotation!

    override func viewDidLoad() {
        super.viewDidLoad()

        commentsTableView.contentInset = UIEdgeInsetsMake(pinCard.frame.height, 0, 0, 0)
        commentsTableView.tableFooterView = UIView()
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        commentsTableView.estimatedRowHeight = 80
        commentsTableView.register(UINib(nibName: "PinCommentCell", bundle: nil) , forCellReuseIdentifier: "PinCommentCell")
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        pinCard.prepare(withPin: pinAnnotation.pin)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = pinCard.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if pinCard.frame.height != size.height {
            pinCardHeightConstraint.constant = size.height
            commentsTableView.contentInset = UIEdgeInsetsMake(pinCard.frame.height, 0, 0, 0)
            view.layoutIfNeeded()
        }
    }
}

extension PinDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "PinCommentCell", for: indexPath) as! PinCommentCell
        cell.commenterLabel.text = "No one"
        cell.commentLabel.text = "Fake!"
        return cell
    }
}
