//
//  MainTabBarController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    fileprivate let profileButton: UIBarButtonItem = {
        let buttonDiameter: CGFloat = 32
        let button = UIButton(type: .system)
        button.setDimensions(height: buttonDiameter, width: buttonDiameter)
        button.layer.cornerRadius = buttonDiameter / 2
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.Resfeber.red.cgColor
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .systemGray3
        button.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)

        let image = UIImage(systemName: "person.fill")?.withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        
        return UIBarButtonItem(customView: button)
    }()
        
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITabBar.appearance().tintColor = UIColor.Resfeber.red
        configureViewControllers()
    }
    
    // MARK: - Selectors

    @objc fileprivate func profileImageTapped() {
        print("DEBUG: profileImageTapped..")
    }

    // MARK: - Helpers
    
    private func configureViewControllers() {
        let destinationController = DestinationController()
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        
        let exploreVC = ExploreViewController(destinationController: destinationController)
        let exploreTabImage = UIImage(systemName: "house", withConfiguration: symbolConfig)
        let exploreNav = tabNavigationController(rootViewController: exploreVC,
                                                 tabImage: exploreTabImage,
                                                 navBarTitle: "Explore")
        
        let favoritesVC = FavoritesViewController(destinationController: destinationController)
        let favoritesTabImage = UIImage(systemName: "heart", withConfiguration: symbolConfig)
        let favoritesNav = tabNavigationController(rootViewController: favoritesVC,
                                                   tabImage: favoritesTabImage,
                                                   navBarTitle: "Favorites")
        
        let itineraryVC = ItineraryViewController(destinationController: destinationController)
        let itineraryTabImage = UIImage(systemName: "briefcase", withConfiguration: symbolConfig)
        let itineraryNav = tabNavigationController(rootViewController: itineraryVC,
                                                   tabImage: itineraryTabImage,
                                                   navBarTitle: "Itinerary")
        
        viewControllers = [exploreNav, favoritesNav, itineraryNav]
    }
    
    private func tabNavigationController(rootViewController: UIViewController, tabImage: UIImage?, navBarTitle: String? = nil) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = tabImage
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.text = navBarTitle
        
        rootViewController.navigationItem.titleView = titleLabel
        rootViewController.navigationItem.rightBarButtonItem = profileButton
        
        return navController
    }
}
