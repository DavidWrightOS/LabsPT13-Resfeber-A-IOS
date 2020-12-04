//
//  ContainerController.swift
//  Resfeber
//
//  Created by David Wright on 11/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate var sideMenuController: SideMenuController!
    fileprivate var mainNavigationController: UINavigationController!
    fileprivate var tripsViewController: TripsViewController!
    fileprivate let darkTintView = UIView()
    fileprivate var isExpanded = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainNavigationController()
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .slide }
    override var prefersStatusBarHidden: Bool { isExpanded }
    
    // MARK: - Helpers
    
    fileprivate func configureMainNavigationController() {
        tripsViewController = TripsViewController()
        tripsViewController.sideMenuDelegate = self
        mainNavigationController = UINavigationController(rootViewController: tripsViewController)
        view.addSubview(mainNavigationController.view)
        addChild(mainNavigationController)
        mainNavigationController.didMove(toParent: self)
        
        // Configure Dark Tint View
        darkTintView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        darkTintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        darkTintView.alpha = 0
        mainNavigationController.view.addSubview(darkTintView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        darkTintView.addGestureRecognizer(tap)
    }
    
    fileprivate func configureMenuController() {
        if sideMenuController == nil {
            sideMenuController = SideMenuController()
            sideMenuController.delegate = self
            view.insertSubview(sideMenuController.view, at: 0)
            addChild(sideMenuController)
            sideMenuController.didMove(toParent: self)
            sideMenuController.view.frame.origin.x = -view.frame.width
        }
    }
    
    fileprivate func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .editProfile:
            let nav = UINavigationController(rootViewController: ProfileViewController())
            present(nav, animated: true, completion: nil)
        case .logOut:
            break //TODO: Log user out
        }
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func dismissMenu() {
        isExpanded = false
        animateSideMenu(shouldExpand: isExpanded, menuOption: nil)
    }
    
    @objc fileprivate func profileImageTapped() {
        toggleSideMenu(withMenuOption: nil)
    }
    
    // MARK: - Animation
    
    fileprivate func animateSideMenu(shouldExpand: Bool, menuOption: MenuOption?) {
        
        if shouldExpand {
            // Show side menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 5.0,
                           options: .curveEaseOut,
                           animations: {
                            self.sideMenuController.view.frame.origin.x = 0
                            self.mainNavigationController.view.frame.origin.x = self.view.frame.width - 80
                            self.darkTintView.alpha = 1
                            self.tripsViewController.profileButton.customView?.alpha = 0
                           }, completion: nil)
            
        } else {
            // Hide side menu
            self.darkTintView.alpha = 0
            UIView.animate(withDuration: 0.15, delay: 0, animations: {
                self.sideMenuController.view.frame.origin.x = -self.view.frame.width
                self.mainNavigationController.view.frame.origin.x = 0
                self.tripsViewController.profileButton.customView?.alpha = 1
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    fileprivate func animateStatusBar() {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.setNeedsStatusBarAppearanceUpdate()
                       }, completion: nil)
    }
}

// MARK: - MainControllerDelegate

extension ContainerController: SideMenuDelegate {
    func toggleSideMenu(withMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        animateSideMenu(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
