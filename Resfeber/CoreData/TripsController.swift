//
//  TripsController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreData

public final class TripsController {
    // MARK: - Properties
    let context: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext,
         coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.context = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

// MARK: - Public
extension TripsController {
    @discardableResult
    public func addTrip(name: String, image: Data? = nil, startDate: Date? = nil, endDate: Date? = nil) -> Trip {
        let trip = Trip(name: name, image: image, startDate: startDate, endDate: endDate, context: context)
        trip.name = name
        trip.image = image
        trip.startDate = startDate
        trip.endDate = endDate
        
        do {
            try coreDataStack.saveContext(context: context)
        } catch {
            print("Error adding trip: \(error)")
        }
        return trip
    }
    
    public func getTrips() -> [Trip]? {
        let tripFetch: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        do {
            let results = try context.fetch(tripFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    public func getTrip(_ id: String) -> Trip? {
        let tripFetch: NSFetchRequest<Trip> = Trip.fetchRequest()
        tripFetch.predicate = NSPredicate(format: "(%K = %@)", #keyPath(Trip.id), id)
        
        do {
            let trip = try context.fetch(tripFetch).first
            return trip
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    @discardableResult
    public func updateTrip(_ trip: Trip) -> Trip {
        do {
            try coreDataStack.saveContext(context: context)
        } catch {
            print("Error adding trip: \(error)")
        }
        return trip
    }
    
    public func deleteTrip(_ trip: Trip) {
        context.delete(trip)
        do {
            try coreDataStack.saveContext(context: context)
        } catch {
            print("Error adding trip: \(error)")
        }
    }
    
    @discardableResult
    public func addEvent(name: String? = nil, eventDescription: String? = nil, category: EventCategory? = nil, latitude: Double? = nil, longitude: Double? = nil, address: String? = nil, startDate: Date? = nil, endDate: Date? = nil, notes: String? = nil, id: String = UUID().uuidString, trip: Trip) -> Event {
        let event = Event(context: context)
        let category = category ?? EventCategory.notSpecified
        event.name = name
        event.eventDescription = eventDescription
        event.categoryRawValue = Int32(category.rawValue)
        event.latitude = latitude ?? 0.0
        event.longitude = longitude ?? 0.0
        event.address = address
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        event.id = id
        event.trip = trip
        
        do {
            try coreDataStack.saveContext(context: context)
        } catch {
            print("Error adding event: \(error)")
        }
        return event
    }
    
    public func getEvents() -> [Event]? {
        let eventFetch: NSFetchRequest<Event> = Event.fetchRequest()
        
        do {
            let results = try context.fetch(eventFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    @discardableResult
    public func updateEvent(_ event: Event) -> Event {
        do {
            try coreDataStack.saveContext(context: context)
        } catch {
            print("Error updating event: \(error)")
        }
        return event
    }
    
    public func deleteEvent(_ event: Event) {
        context.delete(event)
        do {
            try coreDataStack.saveContext(context: context)
        } catch {
            print("Error deleting event: \(error)")
        }
    }
}

