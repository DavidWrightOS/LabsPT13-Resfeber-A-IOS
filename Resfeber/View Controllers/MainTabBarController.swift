//
//  MainTabBarController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
        
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITabBar.appearance().tintColor = UIColor.Resfeber.red
        configureViewControllers()
    }

    // MARK: - Helpers
    
    private func configureViewControllers() {
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        
        let exploreVC = ExploreViewController()
        let exploreTabImage = UIImage(systemName: "house", withConfiguration: symbolConfig)
        let exploreNav = tabNavigationController(rootViewController: exploreVC,
                                                 tabImage: exploreTabImage)
        
        let favoritesVC = FavoritesViewController()
        let favoritesTabImage = UIImage(systemName: "heart", withConfiguration: symbolConfig)
        let favoritesNav = tabNavigationController(rootViewController: favoritesVC,
                                                   tabImage: favoritesTabImage)
        
        let itineraryVC = ItineraryViewController()
        let itineraryTabImage = UIImage(systemName: "briefcase", withConfiguration: symbolConfig)
        let itineraryNav = tabNavigationController(rootViewController: itineraryVC,
                                                   tabImage: itineraryTabImage)
        
        viewControllers = [exploreNav, favoritesNav, itineraryNav]
    }
    
    private func tabNavigationController(rootViewController: UIViewController, tabImage: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = tabImage
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        return navController
    }
}
