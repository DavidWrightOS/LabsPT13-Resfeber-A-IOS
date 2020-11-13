//
//  Data.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/7/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class DestinationData {
    static var destinations = [Destination]()
    
    static var favoriteDestinations: [Destination] {
        destinations.filter { $0.isFavorite }
    }
    
    static var itineraryDestinations: [Destination] {
        destinations.filter { $0.isOnItinerary }
    }
}