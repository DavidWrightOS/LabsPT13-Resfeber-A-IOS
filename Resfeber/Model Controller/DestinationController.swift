//
//  DestinationController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class DestinationController {
    
    // MARK: - Properties
    
    private(set) var searchDestinations = [Destination]()
    private(set) var favoriteDestinations = [Destination]()
    private(set) var itineraryDestinations = [Destination]()
    
    // MARK: - Methods
    
    func toggleFavoriteStatus(for destination: Destination) {
        destination.isFavorite.toggle()
        
        if destination.isFavorite {
            favoriteDestinations.append(destination)
        } else {
            favoriteDestinations.removeAll { $0.id == destination.id }
        }
    }
    
    func toggleItineraryStatus(for destination: Destination) {
        destination.isOnItinerary.toggle()
        
        if destination.isOnItinerary {
            itineraryDestinations.append(destination)
        } else {
            itineraryDestinations.removeAll { $0.id == destination.id }
        }
    }
    
    // TODO: Add functionality to create destination or remove method if not necessary
    func createDestination(destination _: Destination) {}

    func readDestinations() {
        if searchDestinations.count == 0 {
            searchDestinations.append(Destination(name: "Cozumel",
                                                  image: UIImage(named: "Cozumel")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "Seattle",
                                                  image: UIImage(named: "Seattle")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "Philadelphia",
                                                  image: UIImage(named: "Philidelphia")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "Bali",
                                                  image: UIImage(named: "Bali")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "Lisbon",
                                                  image: UIImage(named: "Lisbon")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "CozumelTwo",
                                                  image: UIImage(named: "Cozumel")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "SeattleTwo",
                                                  image: UIImage(named: "Seattle")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "PhiladelphiaTwo",
                                                  image: UIImage(named: "Philidelphia")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "BaliTwo",
                                                  image: UIImage(named: "Bali")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "LisbonTwo",
                                                  image: UIImage(named: "Lisbon")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "CozumelThree",
                                                  image: UIImage(named: "Cozumel")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "SeattleThree",
                                                  image: UIImage(named: "Seattle")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "PhiladelphiaThree",
                                                  image: UIImage(named: "Philidelphia")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "BaliThree",
                                                  image: UIImage(named: "Bali")!,
                                                  isFavorite: false))
            searchDestinations.append(Destination(name: "LisbonThree",
                                                  image: UIImage(named: "Lisbon")!,
                                                  isFavorite: false))
        }
    }

    // TODO: Add functionality to update destination or remove method if not necessary
    func updateDestination(destination _: Destination) {}

    // TODO: Add functionality to delete destination or remove method if not necessary
    func deleteDestinatino(destination _: Destination) {}
}
