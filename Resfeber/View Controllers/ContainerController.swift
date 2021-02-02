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
    
    let profileController = ProfileController.shared
    
    private var profile: Profile? {
        didSet {
            guard profile != oldValue else { return }
            loadUserData()
        }
    }
    
    private lazy var sideMenuController: SideMenuController = {
        let sideMenuController = SideMenuController()
        sideMenuController.delegate = self
        view.insertSubview(sideMenuController.view, at: 0)
        addChild(sideMenuController)
        sideMenuController.didMove(toParent: self)
        sideMenuController.view.frame.origin.x = -view.frame.width
        return sideMenuController
    }()
    
    private var mainNavigationController: UINavigationController!
    private var tripsViewController: TripsViewController!
    private let darkTintView = UIView()
    private var isExpanded = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = RFColor.background
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationSuccessful,
                                               object: nil,
                                               queue: .main,
                                               using: loadUserData)
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationExpired,
                                               object: nil,
                                               queue: .main,
                                               using: alertUserOfExpiredCredentials)
        
        configureMainNavigationController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForExistingProfile()
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .slide }
    override var prefersStatusBarHidden: Bool { isExpanded }
    
    // MARK: - Helpers
    
    private func checkForExistingProfile() {
        print("ContainerController.checkForExistingProfile()")
        profileController.checkForExistingAuthenticatedUserProfile { [weak self] exists in
            guard let self = self else { return }
            
            if exists, let profile = self.profileController.authenticatedUserProfile {
                self.profile = profile
            } else {
                self.presentLoginViewController()
            }
        }
    }
    
    private func configureMainNavigationController() {
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
    
    private func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .editProfile:
            let nav = UINavigationController(rootViewController: ProfileViewController())
            present(nav, animated: true, completion: nil)
        case .logOut:
            logoutUser()
        }
    }
    
    private func loadUserData(_ notification: Notification) {
        print("\tNotificationCenter.oktaAuthenticationSuccessful (ContainerController)")
        if profile == nil {
            checkForExistingProfile()
        } else {
            loadUserData()
        }
    }
    
    private func loadUserData() {
        print("\t\tContainerController.loadUserData()")
        tripsViewController.profile = profile
        sideMenuController.profile = profile
    }
    
    private func alertUserOfExpiredCredentials(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presentSimpleAlert(with: "Your Okta credentials have expired",
                                    message: "Please sign in again",
                                    preferredStyle: .alert,
                                    dismissText: "Dimiss") { [weak self] _ in
                guard let self = self else { return }
                self.logoutUser()
            }
        }
    }
    
    private func logoutUser() {
        presentLoginViewController()
    }
    
    private func presentLoginViewController(animated: Bool = true) {
        let nav = UINavigationController(rootViewController: LoginViewController())
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.prefersLargeTitles = true
        self.present(nav, animated: animated, completion: nil)
    }
    
    // MARK: - Selectors
    
    @objc private func dismissMenu() {
        isExpanded = false
        animateSideMenu(shouldExpand: isExpanded, menuOption: nil)
    }
    
    @objc private func profileImageTapped() {
        toggleSideMenu(withMenuOption: nil)
    }
    
    // MARK: - Animation
    
    private func animateSideMenu(shouldExpand: Bool, menuOption: MenuOption?) {
        
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
    
    private func animateStatusBar() {
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
        isExpanded = !isExpanded
        animateSideMenu(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
