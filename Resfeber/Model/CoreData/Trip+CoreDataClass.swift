//
//  Trip+CoreDataClass.swift
//  Resfeber
//
//  Created by David Wright on 1/15/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//
//

import CoreData
import MapKit

@objc(Trip)
public class Trip: NSManagedObject {
    
    // MARK: - Computed Properties
    
    var serverID: Int? {
        get { return internal_serverID?.intValue }
        set { internal_serverID = newValue != nil ? NSNumber(value: newValue!) : nil }
    }
    
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
    
    // MARK: - Initializers
    
    @discardableResult
    convenience init(name: String? = nil,
                     image: Data? = nil,
                     startDate: Date? = nil,
                     endDate: Date? = nil,
                     events: [Event]? = nil,
                     imageURLString: String? = nil,
                     id: String? = nil,
                     serverID: Int? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = id ?? UUID().uuidString
        self.serverID = serverID
        self.name = name
        self.image = image
        self.startDate = startDate
        self.endDate = endDate
        self.imageURLString = imageURLString
        
        if let events = events {
            self.events = NSSet(object: events)
        }
    }
    
    @discardableResult
    convenience init(_ tripResult: TripResult, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = UUID().uuidString
        self.serverID = tripResult.serverID
        self.name = tripResult.name
        self.imageURLString = tripResult.imageURL
    }
    
    @discardableResult
    convenience init(_ tripResultWithEvents: TripResultWithEvents, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = UUID().uuidString
        self.serverID = tripResultWithEvents.serverID
        self.name = tripResultWithEvents.name
        self.imageURLString = tripResultWithEvents.imageURL
        
        if let eventResults = tripResultWithEvents.events {
            for eventResult in eventResults {
                Event(eventResult, forTrip: self)
            }
        }
    }
}


// MARK: - TripResult, PostTripRequest

extension Trip {
    
    var tripResult: TripResult {
        let userID = ProfileController.shared.authenticatedUserProfile?.id ?? ""
        return TripResult(serverID: serverID, userID: userID, name: name, imageURL: imageURLString)
    }
    
    var tripResultWithEvents: TripResultWithEvents {
        let userID = ProfileController.shared.authenticatedUserProfile?.id ?? ""
        return TripResultWithEvents(serverID: serverID, userID: userID, name: name, imageURL: imageURLString, events: [])
    }
    
    var tripPOSTRequest: TripPOSTRequest {
        let userID = ProfileController.shared.authenticatedUserProfile?.id ?? ""
        return TripPOSTRequest(userID: userID, name: name, imageURL: imageURLString, events: nil)
    }
}


// MARK: - Mapping

extension Trip {
    
    var eventsCoordinateRegion: MKCoordinateRegion? {
        guard !eventsArray.isEmpty else { return nil }
        
        var mapRect = MKMapRect.null
        
        eventsArray.forEach { event in
            let annotationPoint = MKMapPoint(event.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            mapRect = mapRect.union(pointRect)
        }
        
        return MKCoordinateRegion(mapRect)
    }
}

