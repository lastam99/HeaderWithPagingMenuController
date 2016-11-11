//
//  ViewController.swift
//  HeaderWithPagingMenu
//
//  Created by lastam99 on 2016. 10. 19..
//  Copyright © 2016년 lastam99. All rights reserved.
//

import UIKit
import PagingMenuController

// MARK - View Controller

class ViewController: UIViewController {
	
	@IBOutlet weak var profile: UILabel!
	@IBOutlet weak var container: UIView!
    @IBOutlet weak var headerConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UILabel!
    
	private var table1: SomeTableViewController? = SomeTableViewController()
    private var table2: SomeTableViewController? = SomeTableViewController()
    private var table3: SomeTableViewController? = SomeTableViewController()

	
	var headerOffset: CGFloat = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		table1?.headerConstraintDelegate = self
		table2?.headerConstraintDelegate = self
        table3?.headerConstraintDelegate = self
		
		setupFramework()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK - Paging Scroll Menu
	
	func setupFramework() {
		struct MenuItem1: MenuItemViewCustomizable {}
		struct MenuItem2: MenuItemViewCustomizable {}
        struct MenuItem3: MenuItemViewCustomizable {}
		
		struct MenuOptions: MenuViewCustomizable {
			var itemsOptions: [MenuItemViewCustomizable] {
				return [MenuItem1(), MenuItem2(), MenuItem3()]
			}
            var displayMode: MenuDisplayMode {
                return .segmentedControl
            }
		}
		
		struct PagingMenuOptions: PagingMenuControllerCustomizable {
			var custom1: UIViewController?
			var custom2: UIViewController?
            var custom3: UIViewController?
			
			var componentType: ComponentType {
				return .all(menuOptions: MenuOptions(), pagingControllers: [custom1!, custom2!, custom3!])
			}
			
			mutating func setComp1(vc: UIViewController?) {
				custom1 = vc
			}
			
			mutating func setComp2(vc: UIViewController?) {
				custom2 = vc
			}
            
            mutating func setComp3(vc: UIViewController?) {
                custom3 = vc
            }
		}
		
		var options = PagingMenuOptions()
		options.setComp1(vc: self.table1)
		options.setComp2(vc: self.table2)
        options.setComp3(vc: self.table3)
		
		let pagingMenuController = self.childViewControllers.first as! PagingMenuController
		pagingMenuController.delegate = self
		pagingMenuController.setup(options)
	}
	
}

// MARK: - Paging Menu Controller Delegate

extension ViewController: PagingMenuControllerDelegate {
	
	func didMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
        
        // disabled header resizing when menu item changed
//		let from = previousMenuController as! SomeTableViewController
//		
//		updateHeaderConstraint(headerOffset, animate: true)
//		headerOffset = from.currentOffset()
	}
}

// MARK: - Header Constraint Delegate

protocol HeaderConstraintDelegate: class {
    
    var headerHeight: CGFloat { get }
    var statusBarHeight: CGFloat { get }
    var currentHeaderConstraint: CGFloat { get }
    func updateHeaderConstraint(_ constant: CGFloat, animate: Bool)
}

extension ViewController: HeaderConstraintDelegate {
    var headerHeight: CGFloat {
        return self.headerView.frame.size.height + UIApplication.shared.statusBarFrame.height
    }
    
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    var currentHeaderConstraint: CGFloat {
        return self.headerConstraint.constant + statusBarHeight
    }

	func updateHeaderConstraint(_ constant: CGFloat, animate: Bool) {
		self.headerConstraint.constant = constant
		if animate {
			UIView.animate(withDuration: 0.250, animations: {
				self.view.layoutIfNeeded()
			})
		}
	}
    
}
