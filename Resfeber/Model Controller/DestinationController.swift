//
//  DestinationController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class DestinationController {
    
    static func createDestination(destination: Destination) {
        
    }
    
    static func readDestinations() {
        if Data.destinations.count == 0 {
            Data.destinations.append(Destination(name: "Cozumel",
                                                 image: UIImage(named: "Cozumel")!,
                                                 isFavorite: false))
            Data.destinations.append(Destination(name: "Seattle",
                                                 image: UIImage(named: "Seattle")!,
                                                 isFavorite: false))
            Data.destinations.append(Destination(name: "Philadelphia",
                                                 image: UIImage(named: "Philidelphia")!,
                                                 isFavorite: false))
            Data.destinations.append(Destination(name: "Bali",
                                                 image: UIImage(named: "Bali")!,
                                                 isFavorite: false))
            Data.destinations.append(Destination(name: "Lisbon",
                                                 image: UIImage(named: "Lisbon")!,
                                                 isFavorite: false))
        }
    }
    
    static func updateDestination(destination: Destination) {
        
    }
    
    static func deleteDestinatino(destination: Destination) {
        
    }
}
