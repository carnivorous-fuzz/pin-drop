//
//  FancyTextField.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/13/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class FancyTextField: UIView {
    
    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var fieldLabelBottomConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle functions
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
    
    private func commonInit() {
        let nib = UINib(nibName: "FancyTextField", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onViewTap))
        )
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
    
    // MARK: Public functions
    func getText() -> String {
        return textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
    }
    
    func getExactText() -> String? {
        return textField.text
    }
    
    func isEmpty() -> Bool {
        return getText().isEmpty
    }
    
    func customize(label: String?, text: String? = nil, isSecure: Bool = false) {
        if let label = label {
            fieldLabel.text = label
        }
        
        if let fixedText = text?.trimmingCharacters(in: .whitespaces), !fixedText.isEmpty {
            moveLabel(isEditing: true)
            textField.text = fixedText
        }
        
        textField.isSecureTextEntry = isSecure
    }
    
    // MARK: Action handlers
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
    
    @objc private func onViewTap() {
        textField.becomeFirstResponder()
    }
    
    // MARK: Helpers
    private func moveLabel(animated: Bool, isEditing: Bool) {
        if animated {
            UIView.animate(withDuration: 0.35) {
                self.moveLabel(isEditing: isEditing)
            }
        } else {
            moveLabel(isEditing: isEditing)
        }
    }
    
    private func moveLabel(isEditing: Bool) {
        self.fieldLabelBottomConstraint.constant = isEditing ? self.textField.bounds.size.height + 8.0 : 0.0
        self.layoutIfNeeded()
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
