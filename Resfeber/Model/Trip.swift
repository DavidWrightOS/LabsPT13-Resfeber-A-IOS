//
//  Trip.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/2/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import UIKit

/// A user-defined Trip.
class Trip {
    /// The trip's name
    var name: String
    /// A user-defined image representing the trip
    var image: UIImage?
    /// The trip's start date
    var startDate: Date?
    /// The trip's end date
    var endDate: Date?
    /// Events associated with a trip
    var eventItems: [EventItem]
    
    init(name: String, eventItems: [EventItem]) {
        self.name = name
        self.eventItems = eventItems
    }
}
