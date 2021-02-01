//
//  Event+CoreDataProperties.swift
//  Resfeber
//
//  Created by David Wright on 1/15/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//
//

import CoreData

extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var address: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: String
    @NSManaged public var locationName: String?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var imageURLString: String?
    @NSManaged public var trip: Trip?
    
    @NSManaged public var internal_serverID: NSNumber?
    @NSManaged public var internal_categoryRawValue: NSNumber?
    @NSManaged public var internal_latitude: NSNumber?
    @NSManaged public var internal_longitude: NSNumber?
}

extension Event : Identifiable {
    
}
