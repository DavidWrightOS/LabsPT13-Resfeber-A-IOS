//
//  RFColor.swift
//  Resfeber
//
//  Created by David Wright on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class RFColor: UIColor {
    static var primaryOrange: UIColor { return rgb(r: 255, g: 81, b: 30) }
    static override var red: UIColor { return UIColor(named: "ResfeberRed")! }
    static var deleteRed: UIColor { return UIColor(named: "ResfeberDeleteRed")! }
    static override var blue: UIColor { return UIColor(named: "ResfeberBlue")! }
    static override var yellow: UIColor { return UIColor(named: "ResfeberYellow")! }
    static override var green: UIColor { return UIColor(named: "ResfeberGreen")! }
    static var dark: UIColor { return UIColor(named: "ResfeberDark")! }
    static var light: UIColor { return UIColor(named: "ResfeberLight")! }
    static var background: UIColor { return UIColor(named: "ResfeberBackground")! }
    static var groupedBackground: UIColor { return UIColor(named: "ResfeberGroupedBackground")! }
}

extension UIColor {
    static func rgb(r: Int, g: Int, b: Int, a: Double = 1.0) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a))
    }
}
