//
//  FancyTextView.swift
//  Sweeper
//
//  Created by Wuming Xie on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

protocol FancyTextViewDelegate: class {
    func fancyTextView(_ fancyTextView: FancyTextView, keyboardWillShow: Bool)
    func fancyTextView(_ fancyTextView: FancyTextView, keyboardWillHide: Bool)
    func fancyTextView(_ fancyTextView: FancyTextView, didComplete: Bool)
}

class FancyTextView: UIView {
    static let maxLimit = 1000

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var limitCountLabel: UILabel!
    @IBOutlet weak var completionButton: UIButton!
    
    var delegate: FancyTextViewDelegate?
    
    private var textLimit = 240
    
    // MARK: Lifecycle functions
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide,
                                                  object: nil)
    }
    
    private func initSubviews() {
        UINib(nibName: "FancyTextView", bundle: nil).instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        inputTextView.delegate = self
        updateLimitCount(animated: false)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }
    
    // MARK: Action outlet
    @IBAction func onComplete(_ sender: UIButton) {
        delegate?.fancyTextView(self, didComplete: true)
    }
    
    // MARK: Public functions
    func customize(placeholder: String? = nil, textLimit: Int? = nil, buttonText: String? = nil) {
        
        if let textLimit = textLimit {
            self.textLimit = max(self.textLimit, min(FancyTextView.maxLimit, textLimit))
        }
    }
    
    // MARK: Notification functions
    @objc private func keyboardWillShow(notification: Notification) {
        guard let delegate = delegate else {
            // Manage constraints as if we were the entire screen
            updateLayout(keyboardWillShow: true, notification: notification)
            return
        }
        
        delegate.fancyTextView(self, keyboardWillShow: true)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let delegate = delegate else {
            // Manage constraints as if we were the entire screen
            updateLayout(keyboardWillShow: false, notification: notification)
            return
        }
        
        // If we have a delegate let it handle any movements if necessary
        delegate.fancyTextView(self, keyboardWillHide: true)
    }
    
    // MARK: Helper
    private func updateLayout(keyboardWillShow: Bool, notification: Notification) {
        let keyboardNotification = KeyboardNotification(notification)
        let height = keyboardNotification.frameEnd.size.height
        UIView.animate(
            withDuration: keyboardNotification.animationDuration,
            delay: 0.0,
            options: [keyboardNotification.animationCurve],
            animations: {
                self.bottomViewBottomConstraint.constant = keyboardWillShow ? -height : 0.0
                self.contentView.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    private func updateCompletionButton() {
        let charCount = inputTextView.text.characters.count
        let enabled = charCount > textLimit || charCount == 0
        completionButton.isEnabled = enabled
        UIView.animate(withDuration: 0.25) {
            self.completionButton.alpha = enabled ? 1.0 : 0.4
        }
    }
    
    private func updateLimitCount() {
        let left = textLimit - inputTextView.text.characters.count
        limitCountLabel.text = "\(left)"
        limitCountLabel.textColor = left < 20 ? UIColor.red : UIColor.black
    }
    
    private func updateLimitCount(animated: Bool) {
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
    
}
