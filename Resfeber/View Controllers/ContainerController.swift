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
        view.addSubview(mainTabBarController.view)
        addChild(mainTabBarController)
        mainTabBarController.didMove(toParent: self)
    }
    
    fileprivate func configureMenuController() {
        if sideMenuController == nil {
            sideMenuController = SideMenuController()
            view.insertSubview(sideMenuController.view, at: 0)
            addChild(sideMenuController)
            sideMenuController.didMove(toParent: self)
            sideMenuController.view.frame.origin.x = -view.frame.width
        }
    }
}

