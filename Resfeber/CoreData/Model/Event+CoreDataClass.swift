//
//  Event+CoreDataClass.swift
//  Resfeber
//
//  Created by David Wright on 1/15/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//
//

import CoreData
import MapKit

@objc(Event)
public class Event: NSManagedObject {
    
    // MARK: - Computed Properties
    
    var category: EventCategory {
        get { return EventCategory(rawValue: internal_categoryRawValue?.intValue ?? 0) ?? .notSpecified }
        set { internal_categoryRawValue = NSNumber(value: newValue.rawValue) }
    }
    
    var latitude: Double? {
        get { return internal_latitude?.doubleValue }
        set { internal_latitude = newValue != nil ? NSNumber(value: newValue!) : nil }
    }
    
    var longitude: Double? {
        get { return internal_longitude?.doubleValue }
        set { internal_longitude = newValue != nil ? NSNumber(value: newValue!) : nil }
    }
    
    var serverID: Int? {
        get { return internal_serverID?.intValue }
        set { internal_serverID = newValue != nil ? NSNumber(value: newValue!) : nil }
    }
    
    // MARK: - Initializers
    
    @discardableResult
    convenience init(forTrip trip: Trip,
                     name: String? = nil,
                     category: EventCategory? = nil,
                     startDate: Date? = nil,
                     endDate: Date? = nil,
                     notes: String? = nil,
                     longitude: Double? = nil,
                     latitude: Double? = nil,
                     address: String? = nil,
                     locationName: String? = nil,
                     imageURLString: String? = nil,
                     id: String? = nil,
                     serverID: Int? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.serverID = serverID
        self.category = category ?? .notSpecified
        self.longitude = longitude
        self.latitude = latitude
        self.id = id ?? UUID().uuidString
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.address = address
        self.locationName = locationName
        self.imageURLString = imageURLString
        
        trip.addToEvents(self)
    }
    
    @discardableResult
    convenience init(_ eventResult: EventResult, forTrip trip: Trip, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.id = UUID().uuidString
        self.serverID = eventResult.serverID
        self.name = eventResult.name
        self.notes = eventResult.notes
        self.imageURLString = eventResult.imageURL
        self.latitude = eventResult.latitude != nil ? Double(eventResult.latitude!) : nil
        self.longitude = eventResult.longitude != nil ? Double(eventResult.longitude!) : nil
        self.startDate = EventResult.dateFormatter.date(from: eventResult.date ?? "")
        
        trip.addToEvents(self)
    }
}


// MARK: - EventResult, EventPOSTRequest

extension Event {
    
    var eventResult: EventResult {
        let userID = ProfileController.shared.authenticatedUserProfile?.id ?? ""
        let tripServerID = trip?.serverID
        let latString = latitude != nil ? String(latitude!) : nil
        let lonString = longitude != nil ? String(longitude!) : nil
        let name = self.name ?? self.locationName
        let dateString = startDate != nil ? EventResult.dateFormatter.string(from: startDate!) : nil
        
        return EventResult(serverID: serverID, userID: userID, tripServerID: tripServerID, name: name, date: dateString, latitude: latString, longitude: lonString, notes: notes, imageURL: imageURLString)
    }
    
    var eventPOSTRequest: EventPOSTRequest {
        let userID = ProfileController.shared.authenticatedUserProfile?.id ?? ""
        let tripServerID = trip?.serverID
        let latString = latitude != nil ? String(latitude!) : nil
        let lonString = longitude != nil ? String(longitude!) : nil
        let name = self.name ?? self.locationName
        let dateString = startDate != nil ? EventResult.dateFormatter.string(from: startDate!) : nil
        
        return EventPOSTRequest(userID: userID, tripServerID: tripServerID, name: name, date: dateString, latitude: latString, longitude: lonString, notes: notes, imageURL: imageURLString)
    }
}


// MARK: - MKAnnotation

extension Event: MKAnnotation {
    
    static let annotationReuseIdentifier = "EventAnnotationView"
    
    public var eventID: String { id }
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
    }
    
    public var title: String? { name ?? locationName }
}
