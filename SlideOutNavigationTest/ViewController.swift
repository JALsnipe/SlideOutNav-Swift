//
//  ViewController.swift
//  SlideOutNavigationTest
//
//  Created by Josh L on 3/31/15.
//  Copyright (c) 2015 Josh L. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ShowMenuItemDelegate {
    
    enum MenuState: Int {
        case MenuStateOpen
        case MenuStateClosed
    }
    
    @IBOutlet weak var containerView: UIView!
    
    var currentMenuState: MenuState = .MenuStateClosed
    var menu: MenuTableViewController = MenuTableViewController()
    
    let tapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // menu setup
        self.menu.view.frame = CGRect(x: -(self.view.frame.size.width / 2), y: 0 + UIApplication.sharedApplication().statusBarFrame.size.height, width: (self.view.frame.size.width / 2), height: self.view.frame.size.height);
        self.navigationController!.view.addSubview(self.menu.view);
        self.navigationController!.view.bringSubviewToFront(self.menu.view)
        self.menu.delegate = self
        
        self.tapRecognizer.addTarget(self, action: "closeMenu")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.menu.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
    }

    @IBAction func showMenu(sender: AnyObject) {
        
        var xValToAnimate: CGFloat
        
        switch currentMenuState {
        case .MenuStateClosed:
            // open
            // view is offscreen, move it on screen
            xValToAnimate = 0;
            currentMenuState = .MenuStateOpen
            
            // add gesture recognizer to close menu
            self.view.addGestureRecognizer(tapRecognizer)
            
        case .MenuStateOpen:
            // close
            xValToAnimate = -(self.view.frame.size.width)
            currentMenuState = .MenuStateClosed
            
            // remove gesture recognizer
            self.view.removeGestureRecognizer(self.tapRecognizer)
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menu.view.frame = CGRect(x: xValToAnimate, y: self.menu.view.frame.origin.y, width: self.menu.view.frame.size.width, height: self.menu.view.frame.size.height)
        })
    }
    
    func closeMenu() {
        switch currentMenuState {
            
        case .MenuStateOpen:
            self.showMenu(self)
            
        default:
            break
        }
    }
    
    // MARK: Show Menu Delegate
    
    func showMenuItem(menuItem: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let menuItemVC: UIViewController = storyboard.instantiateViewControllerWithIdentifier(menuItem) as! UIViewController;
        
        // remove previous view
        for subview in self.containerView.subviews {
            subview.removeFromSuperview()
        }
        
        self.addChildViewController(menuItemVC);
        
        let menuItemView: UIView = menuItemVC.view
        
        self.containerView.addSubview(menuItemView)
        
        closeMenu()
    }
}

