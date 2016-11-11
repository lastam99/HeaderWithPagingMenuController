//
//  SomeTableViewController.swift
//  pagingscroll
//
//  Created by lastam99 on 2016. 10. 18..
//  Copyright © 2016년 mojitok. All rights reserved.
//

import UIKit

class SomeTableViewController: UITableViewController {

	weak var headerConstraintDelegate: HeaderConstraintDelegate?
	
	var offset: CGFloat = 0				// contentsOffset of table view
	var allowTableScroll: Bool = false	// before header is being unvisible, table view scroll will be disabled

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.showsVerticalScrollIndicator = false
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 32
	}
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
        
		cell.textLabel?.text = "\(indexPath.row)"
        
		return cell
	}
	
	// MARK: - Custom header
	
	func currentOffset() -> CGFloat {
		return offset
	}
    
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let headerHeight = headerConstraintDelegate?.headerHeight,
            let constraint = headerConstraintDelegate?.currentHeaderConstraint,
            let statusBarHeight = headerConstraintDelegate?.statusBarHeight else { return }
        
        // header visible, scroll down -> case 3
        if -headerHeight + statusBarHeight < constraint {
            // header visible, scroll down -> case 2
            offset = -constraint + scrollView.contentOffset.y
            // current header constraint + table view offset
            allowTableScroll = false
        } else {
            // header invisible
            offset = headerHeight + scrollView.contentOffset.y
            // scroll up -> case 1, scroll down -> case 2
            allowTableScroll = true
        }
        
        if offset >= headerHeight {
            // case 1
            offset = -headerHeight + statusBarHeight
        } else if 0 <= offset && offset < headerHeight {
            // case 2
            offset = -offset
        } else {
            // case 3
            offset = 0
            // TODO: bounce animation
        }
        
        headerConstraintDelegate?.updateHeaderConstraint(offset - statusBarHeight, animate: false)
        
        if !allowTableScroll {
            scrollView.delegate = nil       // prevent callback - maybe not good
            scrollView.contentOffset.y = 0  // this is trigger
            scrollView.delegate = self      // reallocate
        }
	}
    
}
