//
//  Event+CoreDataProperties.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var id: String
    @NSManaged public var categoryRawValue: Int32
    @NSManaged public var address: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var locationName: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var trip: Trip?

}

extension Event : Identifiable {
    var category: EventCategory {
        EventCategory(rawValue: Int(categoryRawValue)) ?? EventCategory.notSpecified
    }
}

extension Event: MKAnnotation {
    
    static let annotationReuseIdentifier = "EventAnnotationView"
    
    public var eventID: String { id }
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var title: String? { locationName }
}
