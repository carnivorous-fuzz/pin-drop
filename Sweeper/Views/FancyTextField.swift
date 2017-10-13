//
//  FancyTextField.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class FancyTextField: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var fieldLabelBottomConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UITextFieldTextDidBeginEditing,
            object: textField
        )
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UITextFieldTextDidEndEditing,
            object: textField
        )
    }
    
    func getText() -> String {
        return textField.text ?? ""
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "FancyTextField", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        setDefaultColors()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(beganEditingHandler),
            name: NSNotification.Name.UITextFieldTextDidBeginEditing,
            object: textField
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(endEditingHandler),
            name: NSNotification.Name.UITextFieldTextDidEndEditing,
            object: textField
        )
    }
    
    @objc private func beganEditingHandler() {
        setHighlightedColors()
        moveLabel(isEditing: true)
    }
    
    @objc private func endEditingHandler() {
        setDefaultColors()
        if textField.text == nil || textField.text!.isEmpty {
            moveLabel(isEditing: false)
        }
    }
    
    private func moveLabel(isEditing: Bool) {
        UIView.animate(withDuration: 0.35) {
            self.fieldLabelBottomConstraint.constant = isEditing ? self.textField.bounds.size.height + 4.0 : 0.0
            self.layoutIfNeeded()
        }
    }
    
    private func setHighlightedColors() {
        fieldLabel.textColor = UIColor.black
        separatorView.backgroundColor = UIConstants.Theme.highlightBlue
    }
    
    private func setDefaultColors() {
        fieldLabel.textColor = UIConstants.Theme.mediumGray
        separatorView.backgroundColor = UIConstants.Theme.mediumGray
    }
}
