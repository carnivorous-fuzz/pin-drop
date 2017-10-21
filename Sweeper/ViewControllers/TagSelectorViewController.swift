//
//  TagSelectorViewController.swift
//  Sweeper
//
//  Created by Raina Wang on 10/20/17.
//  Copyright © 2017 team11. All rights reserved.
//

import UIKit

@objc protocol TagSelectorViewControllerDelegate {
    @objc optional func tagSelected(tagSelectorViewController: TagSelectorViewController, didSelectTag tag: Tag?)
}

class TagSelectorViewController: UIViewController {
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var delegate: TagSelectorViewControllerDelegate?
    
    fileprivate var tags: [Tag]?

    override func viewDidLoad() {
        super.viewDidLoad()
        selectorView.slightlyRoundBorder()
        selectorView.layer.masksToBounds = true
        TagService.sharedInstance.fetchTags(with: 0) { (tags: [Tag]?, error: Error?) in
            self.tags = tags
            self.tableView.reloadData()
        }
    }
    @IBAction func onCancel(_ sender: Any) {
        removeSelf()
    }

	func removeSelf() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

// MARK table delegate
extension TagSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagSelectorCell") as? TagSelectorCell else {
            return TagSelectorCell()
        }
        let tag = tags?[indexPath.row]
        cell.textLabel?.text = tag?.name
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tags != nil {
            return self.tags!.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tag = self.tags?[indexPath.row]
        delegate?.tagSelected?(tagSelectorViewController: self, didSelectTag: tag)
        removeSelf()
    }
}
