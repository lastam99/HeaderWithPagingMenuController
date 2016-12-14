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
    var isHeaderVisible: Bool { get }
    var headerHeight: CGFloat { get }
    var currentHeaderConstraint: CGFloat { get }
    func updateHeaderConstraint(_ constant: CGFloat, animate: Bool)
    func headerBehavior(scrollView: UIScrollView, viewController: UITableViewController)
}

extension ViewController: HeaderConstraintDelegate {
    var isHeaderVisible: Bool {
        // if header is visible, Don't allow table scroll
        return currentHeaderConstraint > -headerHeight
    }
    
    var headerHeight: CGFloat {
        return self.headerView.frame.size.height
    }

    var currentHeaderConstraint: CGFloat {
        return self.headerConstraint.constant
    }

	func updateHeaderConstraint(_ constant: CGFloat, animate: Bool) {
		self.headerConstraint.constant = constant
		if animate {
			UIView.animate(withDuration: 0.250, animations: {
				self.view.layoutIfNeeded()
			})
		}
	}

    func headerBehavior(scrollView: UIScrollView, viewController: UITableViewController) {
        let scrollViewOffset = scrollView.contentOffset.y
        let headerVisible: Bool = isHeaderVisible
        var offset: CGFloat
        
        // scroll down -> case 3
        if headerVisible {
            // scroll down -> case 2
            offset = scrollViewOffset - currentHeaderConstraint
        } else {
            // scroll up -> case 1, scroll down -> case 2
            offset = scrollViewOffset + headerHeight
        }
        
        if offset >= headerHeight {
            // case 1
            offset = -headerHeight
        } else if 0 <= offset && offset < headerHeight {
            // case 2
            offset = -offset
        } else {
            // case 3
            offset = 0
            // TODO: - add bounce animation
        }
        
        self.updateHeaderConstraint(offset, animate: false)
        
        if headerVisible {
            scrollView.delegate = nil                 // prevent callback - maybe not good
            scrollView.contentOffset.y = 0            // this is trigger
            scrollView.delegate = viewController     // reallocate
        }
    }

}
