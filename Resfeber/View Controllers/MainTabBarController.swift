//
//  MainTabBarController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITabBar.appearance().tintColor = UIColor.Resfeber.red
    }
}
