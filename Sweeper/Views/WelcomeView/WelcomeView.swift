//
//  WelcomeView.swift
//  Sweeper
//
//  Created by Wuming Xie on 11/1/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        UINib(nibName: "WelcomeView", bundle: nil).instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        welcomeLabel.text = nil
    }
}
