//
//  PinCommentViewController.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class PinCommentViewController: UIViewController {

    @IBOutlet weak var fancyTextView: FancyTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
