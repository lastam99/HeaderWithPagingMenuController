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
        headerConstraintDelegate?.headerBehavior(scrollView: scrollView, viewController: self)
	}
    
}
