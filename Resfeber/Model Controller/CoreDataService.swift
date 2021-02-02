//
//  CoreDataService.swift
//  Resfeber
//
//  Created by David Wright on 1/27/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import CoreData
import MapKit

// MARK: - Public

class CoreDataService {
    
    let context: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext,
         coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.context = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

// MARK: - Trip CRUD (Public)

extension CoreDataService {
    
    func fetchTrips() -> [Trip]? {
        let tripFetch: NSFetchRequest<Trip> = Trip.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: #keyPath(Trip.startDate), ascending: false),
                               NSSortDescriptor(key: #keyPath(Trip.name), ascending: true)]
        tripFetch.sortDescriptors = sortDescriptors
        
        do {
            let results = try context.fetch(tripFetch)
            return results
        } catch let error as NSError {
            NSLog("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }
    
    @discardableResult
    public func createTrip(name: String, image: Data? = nil, startDate: Date? = nil, endDate: Date? = nil, id: String? = nil) -> Trip {
        let trip = Trip(name: name, image: image, startDate: startDate, endDate: endDate, id: id, context: context)
        saveContext()
        return trip
    }
    
    @discardableResult
    public func updateTrip(_ trip: Trip) -> Trip {
        saveContext()
        return trip
    }
    
    public func deleteTrip(_ trip: Trip) {
        context.delete(trip)
        saveContext()
    }
}


// MARK: - Event CRUD (Public)

extension CoreDataService {
    
    @discardableResult
    public func createEvent(forTrip trip: Trip, name: String? = nil, locationName: String? = nil, category: EventCategory? = nil, latitude: Double? = nil, longitude: Double? = nil, address: String? = nil, startDate: Date? = nil, endDate: Date? = nil, notes: String? = nil, id: String = UUID().uuidString) -> Event {
        
        let event = Event(forTrip: trip, name: name, category: category, startDate: startDate, endDate: endDate, notes: notes, longitude: longitude, latitude: latitude, address: address, locationName: locationName, id: id, context: context)
        
        saveContext()
        return event
    }
    
    @discardableResult
    public func updateEvent(_ event: Event) -> Event {
        saveContext()
        return event
    }
    
    public func deleteEvent(_ event: Event) {
        context.delete(event)
        saveContext()
    }
}


// MARK: - Other Methods (Public)

extension CoreDataService {
    
    func saveContext() {
        do {
            try coreDataStack.saveContext(context: context)
        } catch {
            NSLog("Error saving to Core Data: \(error)")
        }
    }
    
    func updateServerID(_ serverID: Int?, for trip: Trip) {
        trip.serverID = serverID
        saveContext()
    }
        
    func updateServerID(_ serverID: Int?, for event: Event) {
        event.serverID = serverID
        saveContext()
    }
    
    func updateLocationInfo(for event: Event, completion: @escaping ((Bool) -> Void) = { _ in }) {
        guard let latitude = event.latitude, let longitude = event.longitude else {
            completion(false)
            return
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        location.fetchPlacemark { placemark in
            guard let placemark = placemark else {
                completion(false)
                return
            }
            
            event.address = placemark.address
            event.locationName = placemark.name
            completion(true)
        }
    }
}

    
// MARK: - Trip CRUD (Private)

extension CoreDataService {
    
    private func fetchTrip(id: String) -> Trip? {
        let tripFetch: NSFetchRequest<Trip> = Trip.fetchRequest()
        tripFetch.predicate = NSPredicate(format: "(%K = %@)", (\Trip.id)._kvcKeyPathString!, id)
        
        do {
            let trip = try context.fetch(tripFetch).first
            return trip
        } catch let error as NSError {
            NSLog("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }
    
    private func fetchTripWithServerID(_ serverID: String) -> Trip? {
        let tripFetch: NSFetchRequest<Trip> = Trip.fetchRequest()
        tripFetch.predicate = NSPredicate(format: "(%K = %@)", (\Trip.serverID)._kvcKeyPathString!, serverID)
        
        do {
            let trip = try context.fetch(tripFetch).first
            return trip
        } catch let error as NSError {
            NSLog("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }
    
    @discardableResult
    func createTrip(_ tripResult: TripResult) -> Trip {
        let trip = Trip(tripResult, context: context)
        saveContext()
        return trip
    }
    
    @discardableResult
    func createTrip(_ tripResultWithEvents: TripResultWithEvents) -> Trip {
        let trip = Trip(tripResultWithEvents, context: context)
        saveContext()
        return trip
    }
    
    func updateTrip(_ trip: Trip, with tripResult: TripResult) {
        trip.serverID = tripResult.serverID
        trip.name = tripResult.name
        trip.imageURLString = tripResult.imageURL
        updateTrip(trip)
    }
}


// MARK: - Event CRUD (Private)

extension CoreDataService {
    
    private func fetchEvents() -> [Event]? {
        let eventFetch: NSFetchRequest<Event> = Event.fetchRequest()
        
        do {
            let results = try context.fetch(eventFetch)
            return results
        } catch let error as NSError {
            NSLog("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }
    
    private func fetchEvent(id: String) -> Event? {
        let eventFetch: NSFetchRequest<Event> = Event.fetchRequest()
        eventFetch.predicate = NSPredicate(format: "(%K = %@)", (\Event.id)._kvcKeyPathString!, id)
        
        do {
            let event = try context.fetch(eventFetch).first
            return event
        } catch let error as NSError {
            NSLog("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }
    
    private func fetchEvents(for trip: Trip) -> [Event]? {
        fetchTrip(id: trip.id)?.eventsArray
    }
    
    @discardableResult
    func createEvent(_ eventResult: EventResult, forTrip trip: Trip) -> Event {
        let event = Event(eventResult, forTrip: trip, context: context)
        saveContext()
        
        updateLocationInfo(for: event) { success in
            if success {
                self.updateEvent(event)
            }
        }
        
        return event
    }
}

