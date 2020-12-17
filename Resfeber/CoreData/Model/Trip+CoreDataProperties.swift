//
//  Trip+CoreDataProperties.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension Trip {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension Trip : Identifiable {
    var eventsArray: [Event] {
        let eventsArray = events?.allObjects as? [Event] ?? []
        
        /// Events are sorted by start date in ascending order
        /// If an event does not have a start date, the end date is used
        /// If the dates are equal, events sorted by end date appear before events sorted by start date
        /// Events with no start or end date are positioned at the end
        return eventsArray.sorted { (a, b) -> Bool in
            if let aStartDate = a.startDate {
                if let bStartDate = b.startDate {
                    return aStartDate < bStartDate
                } else if let bEndDate = b.endDate {
                    return aStartDate < bEndDate
                } else {
                    return true
                }
            } else if let aEndDate = a.endDate {
                if let bStartDate = b.startDate {
                    return aEndDate <= bStartDate
                } else if let bEndDate = b.endDate {
                    return aEndDate < bEndDate
                } else {
                    return true
                }
            }
            return false
        }
    }
}
