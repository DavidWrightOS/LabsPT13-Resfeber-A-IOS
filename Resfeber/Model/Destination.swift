//
//  Destination.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class Destination {
    
    var id: String
    var name: String
    var image: UIImage? = nil
    var isFavorite: Bool = false
    
    init(name: String, image: UIImage, isFavorite: Bool) {
        id = UUID().uuidString
        self.name = name
        self.image = image
        self.isFavorite = isFavorite
    }
    
    
}
