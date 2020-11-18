//
//  SideMenuController.swift
//  Resfeber
//
//  Created by David Wright on 11/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case EditProfile
    case LogOut
    
    var description: String {
        switch self {
        case .EditProfile: return "Edit Profile"
        case .LogOut: return "Log Out"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .EditProfile: return UIImage(systemName: "person")?.withTintColor(UIColor.Resfeber.light, renderingMode: .alwaysOriginal)
        case .LogOut: return UIImage(systemName: "escape")?.withTintColor(UIColor.Resfeber.light, renderingMode: .alwaysOriginal)
        }
    }
}

class SideMenuController: UIViewController {
    
    // MARK: - Properties
    
    var profile: Profile = ProfileController.shared.profile
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Resfeber.red
    }
}
