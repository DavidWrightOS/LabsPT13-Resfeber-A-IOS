//
//  Trip+CoreDataProperties.swift
//  Resfeber
//
//  Created by David Wright on 1/15/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//
//

import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var id: String
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var imageURLString: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var events: NSSet?
    
    @NSManaged public var internal_serverID: NSNumber?

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

}
