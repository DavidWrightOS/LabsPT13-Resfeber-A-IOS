//
//  TripsController.swift
//  Resfeber
//
//  Created by David Wright on 1/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//
// Asynchronous Client-Server Sync Architecture (A-CS)
//
// Data is synced across two data stores:
//     1) Core Data (local/client-side)
//     2) Heroku Web Server (server-side)
//
// This TripsController class provides a client-side API for handling the basic CRUD operations throughout the app.
// The data syncing logic is handled internally, creating an easy-to-use interface for interacting with the data.
//

import CoreData

protocol TripsControllerDelegate: class {
    func didUpdateTrips()
}

// MARK: - Public

class TripsController {
    
    typealias CompletionHandler<T: Decodable> = (Result<T, NetworkError>) -> Void
    
    weak var delegate: TripsControllerDelegate?
    
    private let coreDataService: CoreDataService
    private let webService = RFWebService()
    
    private(set) var trips = [Trip]()
    
    init(managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataService = CoreDataService(managedObjectContext: managedObjectContext, coreDataStack: coreDataStack)
    }
}

// MARK: - Trip CRUD

extension TripsController {
    
    func loadTrips() {
        webService.getTripsAndItems { tripResultsWithEventResults in
            let tripResultsWithEvents = tripResultsWithEventResults ?? []
            
            let trips = self.coreDataService.fetchTrips() ?? []
            self.trips = trips
            
            self.sync(tripResultsWithEvents: tripResultsWithEvents, with: trips)
        }
    }
    
    func trip(id: String) -> Trip? {
        trips.first(where: { $0.id == id })
    }
    
    @discardableResult
    func addTrip(name: String, image: Data? = nil, startDate: Date? = nil, endDate: Date? = nil, id: String? = nil) -> Trip {
        let trip = coreDataService.createTrip(name: name, image: image, startDate: startDate, endDate: endDate, id: id)
        trips.append(trip)
        delegate?.didUpdateTrips()
        
        webService.postTrip(trip) { tripResult in
            guard let tripServerID = tripResult?.serverID else { return }
            self.coreDataService.updateServerID(tripServerID, for: trip)
        }
        
        return trip
    }
    
    @discardableResult
    func updateTrip(_ trip: Trip) -> Trip {
        coreDataService.updateTrip(trip)
        webService.putTrip(trip)
        
        for event in trip.eventsArray {
            updateEvent(event)
        }
        
        delegate?.didUpdateTrips()
        
        return trip
    }
    
    func deleteTrip(_ trip: Trip) {
        trips.removeAll(where: { $0 == trip })
        webService.deleteTrip(trip) { [weak self] isDeleted in
            guard let self = self, isDeleted else { return }
            self.coreDataService.deleteTrip(trip)
        }
        delegate?.didUpdateTrips()
    }
}


// MARK: - Event CRUD

extension TripsController {
    
    @discardableResult
    func addEvent(name: String? = nil, locationName: String? = nil, category: EventCategory? = nil, latitude: Double? = nil, longitude: Double? = nil, address: String? = nil, startDate: Date? = nil, endDate: Date? = nil, notes: String? = nil, id: String = UUID().uuidString, trip: Trip) -> Event {
        
        let event = coreDataService.createEvent(forTrip: trip, name: name, locationName: locationName, category: category, latitude: latitude, longitude: longitude, address: address, startDate: startDate, endDate: endDate, notes: notes, id: id)
        
        delegate?.didUpdateTrips()
        
        updateLocationInfo(for: event) { event in
            self.coreDataService.updateEvent(event)
            
            self.webService.postEvent(event) { eventResult in
                guard let eventServerID = eventResult?.serverID else { return }
                self.coreDataService.updateServerID(eventServerID, for: event)
            }
        }
        
        return event
    }
    
    @discardableResult
    func updateEvent(_ event: Event) -> Event {
        coreDataService.updateEvent(event)
        delegate?.didUpdateTrips()
        webService.putEvent(event)
        return event
    }
    
    func deleteEvent(_ event: Event) {
        webService.deleteEvent(event)
        coreDataService.deleteEvent(event)
        delegate?.didUpdateTrips()
    }
}


// MARK: - Private

extension TripsController {
    
    private func updateLocationInfo(for event: Event, completion: @escaping ((Event) -> Void) = { _ in }) {
        guard let latitude = event.latitude, let longitude = event.longitude else { return }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        location.fetchPlacemark { placemark in
            event.address = placemark?.address
            event.locationName = placemark?.name
            
            DispatchQueue.main.async { completion(event) }
        }
    }
    
    @discardableResult
    private func addTripToCoreData(_ tripResult: TripResult) -> Trip {
        let trip = coreDataService.createTrip(tripResult)
        
        guard trip.eventsArray.isEmpty, let tripServerID = trip.serverID else { return trip }
        
        /// Check if there are events on the server for this trip that may not have been included in the tripResult response
        webService.getEvents(forTripID: tripServerID) { eventResults in
            guard let eventResults = eventResults else { return }
            
            for eventResult in eventResults {
                self.coreDataService.createEvent(eventResult, forTrip: trip)
            }
            
            self.delegate?.didUpdateTrips()
        }
        
        return trip
    }
}


// MARK: - Sync Trips

extension TripsController {
    
    private func sync(tripResultsWithEvents: [TripResultWithEvents], with trips: [Trip]) {
        
        var coreDataTripsByServerID = [Int: Trip]()
        var coreDataTripsNotOnServer = [Trip]()
        
        for trip in trips {
            if let serverSideID = trip.serverID {
                coreDataTripsByServerID[serverSideID] = trip
            } else {
                coreDataTripsNotOnServer.append(trip)
            }
        }
        
        for tripResultWithEvents in tripResultsWithEvents {
            let tripResult = tripResultWithEvents.tripResult
            
            guard let tripServerID = tripResult.serverID else {
                NSLog("Warning: TripResult retrieved from server is missing an `id`. Did not sync TripResult")
                continue
            }
            
            if let trip = coreDataTripsByServerID[tripServerID] {
                
                // Sync Trips that exist both on the server and in Core Data
                /// Check for differences between client-side and server-side trips, and update trip data accordingly
                /// This implementation always uses the server-side trip as the source of truth
                updateTrip(trip, with: tripResult)
            } else {
                
                // Sync Trips that exist only on the server
                /// Create trip and save to Core Data
                let trip = addTripToCoreData(tripResult)
                self.trips.append(trip)
            }
            
            delegate?.didUpdateTrips()
        }
        
        // Sync Trips that exist only in Core Data
        /// POST trips to server and set the returned serverIDs on the local (Core Data) copy of trip
        /// For each event in a trip, POST the event to server and set the returned serverID on the local (Core Data) copy of event
        for trip in coreDataTripsNotOnServer {
            
            webService.postTrip(trip) { tripResult in
                guard let tripServerID = tripResult?.serverID else { return }
                self.coreDataService.updateServerID(tripServerID, for: trip)
                
                for event in trip.eventsArray {
                    
                    self.webService.postEvent(event) { eventResult in
                        guard let eventServerID = eventResult?.serverID else { return }
                        self.coreDataService.updateServerID(eventServerID, for: event)
                    }
                }
            }
        }
    }
    
    private func updateTrip(_ trip: Trip, with tripResult: TripResult) {
        
        trip.serverID = tripResult.serverID
        trip.name = tripResult.name
        trip.imageURLString = tripResult.imageURL
        
        guard let tripServerID = tripResult.serverID else { return }
        
        webService.getEvents(forTripID: tripServerID) { eventResults in
            guard let eventResults = eventResults else { return }
            self.sync(eventResults: eventResults, withEventsForTrip: trip)
        }
    }
}


// MARK: - Sync Events

extension TripsController {
    
    private func sync(eventResults: [EventResult], withEventsForTrip trip: Trip) {
        
        let coreDataEvents = trip.eventsArray
        var coreDataEventsByServerSideID = [Int: Event]()
        var coreDataEventsNotOnServer = [Event]()
        
        for event in coreDataEvents {
            if let serverID = event.serverID {
                coreDataEventsByServerSideID[Int(serverID)] = event
            } else {
                coreDataEventsNotOnServer.append(event)
            }
        }
        
        for eventResult in eventResults {
            guard let eventServerID = eventResult.serverID else {
                NSLog("Warning: EventResult retrieved from server is missing an `serverID`. Did not sync EventResult")
                continue
            }
            
            if let event = coreDataEventsByServerSideID[eventServerID] {
                // Event exists on the server AND in Core Data. Check for differences and sync data
                updateEvent(event, with: eventResult)
                
            } else {
                // Event exists ONLY on the server. Create event and save to Core Data
                let event = coreDataService.createEvent(eventResult, forTrip: trip)
                
                updateLocationInfo(for: event) { event in
                    self.coreDataService.updateEvent(event)
                }
            }
            
            delegate?.didUpdateTrips()
        }
        
        // Events exist that are ONLY in Core Data. POST events to server and set returned serverIDs
        for event in coreDataEventsNotOnServer {
            webService.postEvent(event) { eventResult in
                guard let eventServerID = eventResult?.serverID else { return }
                self.coreDataService.updateServerID(eventServerID, for: event)
            }
        }
    }
    
    @discardableResult
    private func updateEvent(_ event: Event, with eventResult: EventResult) -> Event {
        event.serverID = eventResult.serverID
        event.name = eventResult.name
        event.notes = eventResult.notes
        event.imageURLString = eventResult.imageURL
        event.startDate = EventResult.dateFormatter.date(from: eventResult.date ?? "")

        var locationDidChange = false

        let latitude = Double(eventResult.latitude ?? "")
        if latitude != event.latitude {
            event.latitude = latitude
            locationDidChange = true
        }

        let longitude = Double(eventResult.longitude ?? "")
        if longitude != event.longitude {
            event.longitude = longitude
            locationDidChange = true
        }

        if locationDidChange {
            updateLocationInfo(for: event) { event in
                self.updateEvent(event)
            }
        }

        return event
    }
}
