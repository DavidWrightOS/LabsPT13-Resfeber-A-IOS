//
//  DestinationController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class DestinationController {
    // TODO: Add functionality to create destination or remove method if not necessary
    static func createDestination(destination _: Destination) {}

    static func readDestinations() {
        if DestinationData.destinations.count == 0 {
            DestinationData.destinations.append(Destination(name: "Cozumel",
                                                            image: UIImage(named: "Cozumel")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "Seattle",
                                                            image: UIImage(named: "Seattle")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "Philadelphia",
                                                            image: UIImage(named: "Philidelphia")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "Bali",
                                                            image: UIImage(named: "Bali")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "Lisbon",
                                                            image: UIImage(named: "Lisbon")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "CozumelTwo",
                                                            image: UIImage(named: "Cozumel")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "SeattleTwo",
                                                            image: UIImage(named: "Seattle")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "PhiladelphiaTwo",
                                                            image: UIImage(named: "Philidelphia")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "BaliTwo",
                                                            image: UIImage(named: "Bali")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "LisbonTwo",
                                                            image: UIImage(named: "Lisbon")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "CozumelThree",
                                                            image: UIImage(named: "Cozumel")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "SeattleThree",
                                                            image: UIImage(named: "Seattle")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "PhiladelphiaThree",
                                                            image: UIImage(named: "Philidelphia")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "BaliThree",
                                                            image: UIImage(named: "Bali")!,
                                                            isFavorite: false))
            DestinationData.destinations.append(Destination(name: "LisbonThree",
                                                            image: UIImage(named: "Lisbon")!,
                                                            isFavorite: false))
        }
    }

    // TODO: Add functionality to update destination or remove method if not necessary
    static func updateDestination(destination _: Destination) {}

    // TODO: Add functionality to delete destination or remove method if not necessary
    static func deleteDestinatino(destination _: Destination) {}
}
