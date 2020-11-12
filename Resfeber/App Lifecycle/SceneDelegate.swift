//
//  SceneDelegate.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 6/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let tabBar = MainTabBarController()
        let exploreVC = ExploreViewController()
        let favoritesVC = FavoritesViewController()
        let itineraryVC = ItineraryViewController()
        
        tabBar.setViewControllers([exploreVC, favoritesVC, itineraryVC], animated: false)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        
        setupTabBarItems(exploreVC, favoritesVC, itineraryVC)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let context = URLContexts.first else { return }

        let url = context.url
        ProfileController.shared.oktaAuth.receiveCredentials(fromCallbackURL: url) { (result) in
            
            let notificationName: Notification.Name
            do {
                try result.get()
                guard (try? ProfileController.shared.oktaAuth.credentialsIfAvailable()) != nil else { return }
                notificationName = .oktaAuthenticationSuccessful
            } catch {
                notificationName = .oktaAuthenticationFailed
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
        }
    }
    
    fileprivate func setupTabBarItems(_ exploreVC: ExploreViewController, _ favoritesVC: FavoritesViewController, _ itineraryVC: ItineraryViewController) {
        
        exploreVC.tabBarItem = UITabBarItem(title: "Explore",
                                            image: UIImage(systemName: "house", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)),
                                            tag: 0)
        
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites",
                                              image: UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)),
                                              tag: 1)
        
        itineraryVC.tabBarItem = UITabBarItem(title: "Itinerary",
                                              image: UIImage(systemName: "briefcase", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)),
                                              tag: 2)
    }
}

