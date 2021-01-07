//
//  UIFont+Extension.swift
//  Resfeber
//
//  Created by David Wright on 1/6/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIFont {
    public func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    public var italic : UIFont {
        return withTraits(.traitItalic)
    }
    public var bold : UIFont {
        return withTraits(.traitBold)
    }
}
