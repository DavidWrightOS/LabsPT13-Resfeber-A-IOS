//
//  UIColor+Extension.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/6/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIColor {
    /// UIColor extension for app Color Sets
  struct Resfeber {
    static var red: UIColor  { return UIColor(named: "ResfeberRed")! }
    static var deleteRed: UIColor  { return UIColor(named: "ResfeberDeleteRed")! }
    static var blue: UIColor  { return UIColor(named: "ResfeberBlue")! }
    static var yellow: UIColor  { return UIColor(named: "ResfeberYellow")! }
    static var green: UIColor  { return UIColor(named: "ResfeberGreen")! }
    static var dark: UIColor  { return UIColor(named: "ResfeberDark")! }
    static var light: UIColor  { return UIColor(named: "ResfeberLight")! }
    static var background: UIColor  { return UIColor(named: "ResfeberBackground")! }
  }
}
