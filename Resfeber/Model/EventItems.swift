//
//  EventItems.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/2/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EventItem {
    /// The event's category
    var category: Category
    /// The event's name
    var name: String
    /// The event's latitude and longitude
    var location: CLLocation?
    /// The event's description
    var description: String?
    /// The event's start date
    var startDate: Date?
    /// The event's end date
    var endDate: Date?
    /// The event's list of places to go and things to do.
    var list: [ListItem]?
    /// The event's notes
    var notes: String?
    
    /// Default categories for events
    enum Category: String {
        case accommodation = "Accommodation"
        case activity = "Activity"
        case excursion = "Excursion"
        case restaurant = "Restaurant"
        case event = "Event"
        case other = "Other"
    }
    
    init(category: Category, name: String) {
        self.category = category
        self.name = name
    }
}

extension EventItem {
    /// An item in an event's list.
    class ListItem {
        var type: ListItemType
        /// Description of the event
        var text: String
        
        enum ListItemType {
            case heading
            case checkboxEmpty
            case checkboxFilled
            case newLine
        }
        
        init(type: ListItemType, text: String) {
            self.type = type
            self.text = text
        }
    }
}
