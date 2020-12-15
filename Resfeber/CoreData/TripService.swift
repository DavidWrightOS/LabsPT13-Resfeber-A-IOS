//
//  TripService.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreData

public final class TripService {
    // MARK: - Properties
    let context = CoreDataStack.shared.mainContext
    
    private(set) var searchTrips = [Trip]()
}

// MARK: - Public
extension TripService {
    @discardableResult
    public func addTrip(name: String, image: Data?, startDate: Date?, endDate: Date? ) -> Trip {
        let trip = Trip(name: name, image: image, startDate: startDate, endDate: endDate, context: context)
        trip.name = name
        trip.image = image
        trip.startDate = startDate
        trip.endDate = endDate
        
        do {
            try CoreDataStack.shared.saveContext(context: context)
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
    
    public func getTrip(withName name: String) -> Trip? {
        let tripFetch: NSFetchRequest<Trip> = Trip.fetchRequest()
        tripFetch.predicate = NSPredicate(format: "(%K = %@)", #keyPath(Trip.name), name)
        
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
            try CoreDataStack.shared.saveContext(context: context)
        } catch {
            print("Error adding trip: \(error)")
        }
        return trip
    }
    
    public func deleteTrip(_ trip: Trip) {
        context.delete(trip)
        do {
            try CoreDataStack.shared.saveContext(context: context)
        } catch {
            print("Error adding trip: \(error)")
        }
    }
    
    @discardableResult
    public func addEvent(name: String, eventDescription: String?, category: String?, latitude: Double?, longitude: Double?, startDate: Date?, endDate: Date?, notes: String?, trip: Trip) -> Event {
        let event = Event(context: context)
        event.name = name
        event.eventDescription = eventDescription
        event.category = category
        event.latitude = latitude ?? 0.0
        event.longitude = longitude ?? 0.0
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        event.trip = trip
        
        do {
            try CoreDataStack.shared.saveContext(context: context)
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
            try CoreDataStack.shared.saveContext(context: context)
        } catch {
            print("Error updating event: \(error)")
        }
        return event
    }
    
    public func deleteEvent(_ event: Event) {
        context.delete(event)
        do {
            try CoreDataStack.shared.saveContext(context: context)
        } catch {
            print("Error deleting event: \(error)")
        }
    }
}

