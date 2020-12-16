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
        
        /// Events sorted by date; events without a date are positioned at the end
        return eventsArray.sorted { (x, y) -> Bool in
            
            if let xStartDate = x.startDate {
                if let yStartDate = y.startDate {
                    return xStartDate < yStartDate
                } else {
                    return true
                }
            }
            
            return y.startDate == nil
        }
    }
}
