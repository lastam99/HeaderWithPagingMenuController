//
//  ViewController.swift
//  HeaderWithPagingMenu
//
//  Created by lastam99 on 2016. 10. 19..
//  Copyright © 2016년 lastam99. All rights reserved.
//

import UIKit
import PagingMenuController

class ViewController: UIViewController {
	
	@IBOutlet weak var profile: UILabel!
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var headerConstraint: NSLayoutConstraint!
	
	private var table1: SomeTableViewController? = SomeTableViewController()
	private var table2: SomeTableViewController? = SomeTableViewController()
	
	var headerOffset: CGFloat = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		table1?.headerConstraintDelegate = self
		table2?.headerConstraintDelegate = self
		
		setupFramework()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK - Paging Scroll Menu
	
	func setupFramework() {
		struct MenuItem1: MenuItemViewCustomizable {}
		struct MenuItem2: MenuItemViewCustomizable {}
		
		struct MenuOptions: MenuViewCustomizable {
			var itemsOptions: [MenuItemViewCustomizable] {
				return [MenuItem1(), MenuItem2()]
			}
		}
		
		struct PagingMenuOptions: PagingMenuControllerCustomizable {
			var custom1: UIViewController?
			var custom2: UIViewController?
			
			var componentType: ComponentType {
				return .all(menuOptions: MenuOptions(), pagingControllers: [custom1!, custom2!])
			}
			
			mutating func setComp1(vc: UIViewController?) {
				custom1 = vc
			}
			
			mutating func setComp2(vc: UIViewController?) {
				custom2 = vc
			}
		}
		
		var options = PagingMenuOptions()
		options.setComp1(vc: self.table1)
		options.setComp2(vc: self.table2)
		
		let pagingMenuController = self.childViewControllers.first as! PagingMenuController
		pagingMenuController.delegate = self
		pagingMenuController.setup(options)
	}
	
}

// MARK: - Paging Menu Controller Delegate

extension ViewController: PagingMenuControllerDelegate {
	
	func didMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
		let from = previousMenuController as! SomeTableViewController
		
		updateHeaderConstraint(headerOffset, animate: true)
		headerOffset = from.currentOffset()
	}
	
}

// MARK: - Header Constraint Delegate

protocol HeaderConstraintDelegate: class {
	
	func updateHeaderConstraint(_ constant: CGFloat, animate: Bool)
	func currentHeaderConstraint() -> CGFloat
	
}

extension ViewController: HeaderConstraintDelegate {
	
	func updateHeaderConstraint(_ constant: CGFloat, animate: Bool) {
		self.headerConstraint.constant = constant
		if animate {
			UIView.animate(withDuration: 0.250, animations: {
				self.view.layoutIfNeeded()
			})
		}
	}
	
	func currentHeaderConstraint() -> CGFloat {
		return headerConstraint.constant
	}
	
}
