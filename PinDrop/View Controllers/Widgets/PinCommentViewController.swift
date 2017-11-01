//
//  PinCommentViewController.swift
//  PinDrop
//
//  Created by Wuming Xie on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

class PinCommentViewController: UIViewController {

    @IBOutlet weak var fancyTextView: FancyTextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var commnentedPin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        
        fancyTextView.delegate = self
        fancyTextView.inputTextView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide,
                                                  object: nil)
    }
    
    // MARK: Notification functions
    @objc private func keyboardWillShow(notification: Notification) {
        updateLayout(keyboardWillShow: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        updateLayout(keyboardWillShow: false, notification: notification)
    }

    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        if fancyTextView.hasText() {
            let cancelButton = Dialog.button(title: "Dismiss", type: .cancel, action: nil)
            let discardButton = Dialog.button(title: "Discard", type: .destructive) {
                self.dismissController()
            }

            Dialog.show(controller: self, title: "You have an unfinished comment", message: "Are you sure you want to leave this screen?", buttons: [discardButton, cancelButton], image: nil, dismissAfter: nil, completion: nil)
        } else {
            dismissController()
        }
    }
    
    // MARK: Helpers
    private func updateLayout(keyboardWillShow: Bool, notification: Notification) {
        let keyboardNotification = KeyboardNotification(notification)
        let height = keyboardNotification.frameEnd.size.height
        UIView.animate(
            withDuration: keyboardNotification.animationDuration,
            delay: 0.0,
            options: [keyboardNotification.animationCurve],
            animations: {
                self.textViewBottomConstraint.constant = keyboardWillShow ? -height : 0.0
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
    }
    
    private func dismissController() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

extension PinCommentViewController: FancyTextViewDelegate {
    func fancyTextViewDidComplete(_ fancyTextView: FancyTextView) {
        let pinComment = PinComment()
        pinComment.user = User.currentUser
        pinComment.commentedPin = commnentedPin
        pinComment.comment = fancyTextView.inputTextView.text
        pinComment.saveInBackground()
        dismissController()
    }
}
