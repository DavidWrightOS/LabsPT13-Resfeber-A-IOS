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
    fileprivate var mainTabBarController: MainTabBarController!
    fileprivate var isExpanded = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainTabBarController()
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .slide }
    override var prefersStatusBarHidden: Bool { isExpanded }
    
    // MARK: - Helpers
    
    fileprivate func configureMainTabBarController() {
        mainTabBarController = MainTabBarController()
        mainTabBarController.sideMenuDelegate = self
        
        view.addSubview(mainTabBarController.view)
        addChild(mainTabBarController)
        mainTabBarController.didMove(toParent: self)
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
        case .EditProfile:
            let nav = UINavigationController(rootViewController: ProfileViewController())
            present(nav, animated: true, completion: nil)
        case .LogOut:
            break //TODO: Log user out
        }
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func dismissMenu() {
        isExpanded = false
        animateSideMenu(shouldExpand: isExpanded, menuOption: nil)
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
                            self.mainTabBarController.view.frame.origin.x = self.view.frame.width - 80
                           }, completion: nil)
            
        } else {
            // Hide side menu
            UIView.animate(withDuration: 0.15, delay: 0, animations: {
                self.sideMenuController.view.frame.origin.x = -self.view.frame.width
                self.mainTabBarController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    fileprivate func animateStatusBar() {
        UIView.animate(withDuration: 0.5,
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
