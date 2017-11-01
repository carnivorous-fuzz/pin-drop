//
//  DialogBox.swift
//  PinDrop
//
//  Created by Raina Wang on 10/28/17.
//  Copyright © 2017 team11. All rights reserved.

import Foundation
import UIKit
import PopupDialog

enum buttonType {
    case cancel
    case plain
    case destructive
}

struct Dialog {
    static func button(title: String, type: buttonType, action: (() -> Void)?) -> PopupDialogButton {
        switch type {
        case .cancel:
            return CancelButton(title: title, action: action)
        case .plain:
            return DefaultButton(title: title, action: action)
        case .destructive:
            return DestructiveButton(title: title, action: action)
        }

    }
    static func show(controller: UIViewController, title: String, message: String, buttons: [PopupDialogButton]?, image: UIImage?, dismissAfter: Int?, completion: (() -> Void)?) {
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, gestureDismissal: true)
        
        // Create buttons
        if let buttons = buttons {
            popup.addButtons(buttons)
        }

        // Present dialog
        controller.present(popup, animated: true, completion: completion)
        
        if let dismissAfter = dismissAfter {
            let when = DispatchTime.now() + .seconds(dismissAfter)
            DispatchQueue.main.asyncAfter(deadline: when) {
                popup.dismiss(animated: true, completion: nil)
            }
        }
    }
}
