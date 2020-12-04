//
//  RFColor.swift
//  Resfeber
//
//  Created by David Wright on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class RFColor: UIColor {
    static override var red: UIColor { return UIColor(named: "ResfeberRed")! }
    static var deleteRed: UIColor { return UIColor(named: "ResfeberDeleteRed")! }
    static override var blue: UIColor { return UIColor(named: "ResfeberBlue")! }
    static override var yellow: UIColor { return UIColor(named: "ResfeberYellow")! }
    static override var green: UIColor { return UIColor(named: "ResfeberGreen")! }
    static var dark: UIColor { return UIColor(named: "ResfeberDark")! }
    static var light: UIColor { return UIColor(named: "ResfeberLight")! }
    static var background: UIColor { return UIColor(named: "ResfeberBackground")! }
}
