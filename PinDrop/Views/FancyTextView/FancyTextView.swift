//
//  FancyTextView.swift
//  PinDrop
//
//  Created by Wuming Xie on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

protocol FancyTextViewDelegate: class {
    func fancyTextViewDidComplete(_ fancyTextView: FancyTextView)
}

class FancyTextView: UIView {
    static let maxLimit = 1000

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var limitCountLabel: UILabel!
    @IBOutlet weak var completionButton: UIButton!
    
    var delegate: FancyTextViewDelegate?
    
    private var textLimit = 120
    var placeholder = "What do you think of this pin?"
    
    // MARK: Lifecycle functions
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        UINib(nibName: "FancyTextView", bundle: nil).instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        inputTextView.becomeFirstResponder()
        let cursorPosition = inputTextView.caretRect(for: inputTextView.selectedTextRange!.start).origin
        placeholderLabel.frame.origin = CGPoint(x: cursorPosition.x + 2.0, y: cursorPosition.y)
        inputTextView.resignFirstResponder()
        
        inputTextView.delegate = self
        updateLimitCount(animated: false)
        updateCompletionButton()
    }
    
    // MARK: Action outlet
    @IBAction func onComplete(_ sender: UIButton) {
        delegate?.fancyTextViewDidComplete(self)
    }
    
    // MARK: Public functions
    func customize(placeholder: String? = nil, textLimit: Int? = nil, buttonText: String? = nil) {
        if let placeholder = placeholder {
            self.placeholder = placeholder
        }
        
        if let textLimit = textLimit {
            self.textLimit = max(self.textLimit, min(FancyTextView.maxLimit, textLimit))
        }
        
        if let buttonText = buttonText {
            completionButton.setTitle(buttonText, for: .normal)
        }
    }
    
    func hasText() -> Bool {
        return !inputTextView.text.isEmpty
    }
    
    // MARK: Helper
    fileprivate func updateCompletionButton() {
        let charCount = inputTextView.text.characters.count
        let enabled = charCount <= textLimit || charCount > 0
        completionButton.isEnabled = enabled
        UIView.animate(withDuration: 0.25) {
            self.completionButton.alpha = enabled ? 1.0 : 0.4
        }
    }
    
    fileprivate func updateLimitCount() {
        let left = textLimit - inputTextView.text.characters.count
        limitCountLabel.text = "\(left)"
        limitCountLabel.textColor = left < 20 ? UIColor.red : UIColor.black
    }
    
    fileprivate func updateLimitCount(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.1, animations: {
                self.updateLimitCount()
                self.limitCountLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { (finished) in
                UIView.animate(withDuration: 0.1) {
                    self.limitCountLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        } else {
            updateLimitCount()
        }
    }
}

extension FancyTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if !placeholderLabel.isHidden && hasText() {
            placeholderLabel.isHidden = true
        } else if inputTextView.text.isEmpty {
            placeholderLabel.isHidden = false
        }
        
        updateLimitCount(animated: true)
        updateCompletionButton()
    }
}
