//
//  TableViewHelper.swift
//  Pindrop
//
//  Created by Raina Wang on 10/31/17.
//  Copyright © 2017 team11. All rights reserved.
//

import Foundation
import UIKit

class TableViewHelper {
    class func EmptyMessage(message: String, tableView: UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width,
                                                 height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIConstants.Theme.mediumGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Lato-Light", size: 20)
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = .none;
    }
    class func RemoveMessage(tableView: UITableView) {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
}
