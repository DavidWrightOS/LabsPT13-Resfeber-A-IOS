//
//  SideMenuController.swift
//  Resfeber
//
//  Created by David Wright on 11/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController {
    
    // MARK: - Properties
    
    var profile: Profile = ProfileController.shared.profile
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Resfeber.red
    }
}
