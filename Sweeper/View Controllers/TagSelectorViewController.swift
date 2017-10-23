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
    @IBOutlet weak var searchBar: UISearchBar!

    var delegate: TagSelectorViewControllerDelegate?

    fileprivate var isMoreDataLoading = false
    fileprivate var loadingMoreView:InfiniteScrollActivityView?
    fileprivate var tags = [Tag]()
    fileprivate var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectorView.slightlyRoundBorder()
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)

        loadTags(page: currentPage)
    }
    @IBAction func onCancel(_ sender: Any) {
        removeSelf()
    }

	func removeSelf() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    fileprivate func loadTags(page: Int) {
        TagService.sharedInstance.fetchTags(with: page) { (tags: [Tag]?, error: Error?) in
            if tags != nil {
                self.tags += tags!
                self.tableView.reloadData()
                self.currentPage += 1
            }
            self.loadingMoreView!.stopAnimating()
        }
    }
}

// MARK table delegate
extension TagSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagSelectorCell") as? TagSelectorCell else {
            return TagSelectorCell()
        }
        let tag = tags[indexPath.row]
        cell.textLabel?.text = tag.name
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tags.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tag = self.tags[indexPath.row]
        if (tag.name != nil) && (!tag.name!.isEmpty) {
            delegate?.tagSelected?(tagSelectorViewController: self, didSelectTag: tag)
        }

        removeSelf()
    }
}

// MARK: UIScrollViewDelegate
extension TagSelectorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true

                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                loadTags(page: currentPage)
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension TagSelectorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.loadTags(page: 0)
        } else {
            TagService.sharedInstance.search(with: searchText) { (tags: [Tag]?, error: Error?) in
                if tags != nil {
                    self.tags = tags!
                    self.tableView.reloadData()
                }
            }
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.loadTags(page: 0)
    }
}
