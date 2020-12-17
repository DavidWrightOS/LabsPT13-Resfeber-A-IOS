//
//  TripsControllerTests.swift
//  TripsControllerTests
//
//  Created by Joshua Rutkowski on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import Resfeber
import CoreData

class TripsControllerTests: XCTestCase {
    var tripsController: TripsController!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        tripsController = TripsController(managedObjectContext: coreDataStack.mainContext,
                                  coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        tripsController = nil
        coreDataStack = nil
    }
    
    //MARK: - Trip CRUD tests
    func testAddTrip() {
        let trip = tripsController.addTrip(name: "Wedding",
                                   image: nil,
                                   startDate: nil,
                                   endDate: nil)
        
        XCTAssertNotNil(trip, "Trip should not be nil")
        XCTAssert(trip.name == "Wedding")
    }
    
    /// Tests asynchronous saving
    func testContextIsSavedAfterAddingTrip() {
        // Creates the background context and new instance of TripsController
        let derivedContext = coreDataStack.newDerivedContext()
        tripsController = TripsController(managedObjectContext: derivedContext,
                                  coreDataStack: coreDataStack)
        // Creates an expectation that sends a signal to the test case when Core Data stack sends a notification event
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: derivedContext) { _ in
            return true
        }
        
        // Adds the trip
        derivedContext.perform {
            let trip = self.tripsController.addTrip(name: "Wedding",
                                            image: nil,
                                            startDate: nil,
                                            endDate: nil)
            XCTAssertNotNil(trip)
            XCTAssert(trip.name == "Wedding")
        }
        
        // Waits for the signal that the trip saved.
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testGetTrips() {
        let newTrip = tripsController.addTrip(name: "Road Trip to California",
                                      image: nil,
                                      startDate: nil,
                                      endDate: nil)
        
        let getTrips = tripsController.getTrips()
        
        XCTAssertNotNil(getTrips)
        XCTAssertTrue(getTrips?.count == 1)
        XCTAssertTrue(newTrip.name == getTrips?.first?.name)
    }
    
    func testUpdateTrip() {
        let newTrip = tripsController.addTrip(name: "Endor",
                                      image: nil,
                                      startDate: nil,
                                      endDate: nil)
        newTrip.name = "Hoth"
        let updatedTrip = tripsController.updateTrip(newTrip)
        
        XCTAssertTrue(newTrip.name == updatedTrip.name)
        XCTAssertTrue(updatedTrip.name == "Hoth")
    }
    
    func testDeleteTrip() {
        let newTrip = tripsController.addTrip(name: "Naboo",
                                      image: nil,
                                      startDate: nil,
                                      endDate: nil)
        
        var fetchTrips = tripsController.getTrips()
        
        XCTAssertTrue(fetchTrips?.count == 1)
        XCTAssertTrue(newTrip.name == fetchTrips?.first?.name)
        
        tripsController.deleteTrip(newTrip)
        fetchTrips = tripsController.getTrips()
        
        XCTAssertTrue(fetchTrips?.isEmpty ?? false)
    }
    
    //MARK: - Event CRUD tests
    func testAddEventsToTrip() {
        let trip = tripsController.addTrip(name: "Wedding",
                                   image: nil,
                                   startDate: nil,
                                   endDate: nil)

        let event = tripsController.addEvent(name: "Dinner",
                                         eventDescription: nil,
                                         category: nil,
                                         latitude: nil,
                                         longitude: nil,
                                         startDate: nil,
                                         endDate: nil,
                                         notes: nil,
                                         trip: trip)

        XCTAssertNotNil(trip, "Trip should not be nil")
        XCTAssertNotNil(event, "Event should not be nil")
        XCTAssert(trip.name == "Wedding")
        XCTAssert(event.name == "Dinner")
        XCTAssertTrue(trip.events?.count == 1)
    }
    
    func testGetEvents() {
        let trip = tripsController.addTrip(name: "Wedding",
                                   image: nil,
                                   startDate: nil,
                                   endDate: nil)

        _ = tripsController.addEvent(name: "Dinner",
                                 eventDescription: nil,
                                 category: nil,
                                 latitude: nil,
                                 longitude: nil,
                                 startDate: nil,
                                 endDate: nil,
                                 notes: nil,
                                 trip: trip)
        
        _ = tripsController.addEvent(name: "Movies",
                                 eventDescription: nil,
                                 category: nil,
                                 latitude: nil,
                                 longitude: nil,
                                 startDate: nil,
                                 endDate: nil,
                                 notes: nil,
                                 trip: trip)
        
        
        let getEvents = tripsController.getEvents()
        XCTAssertNotNil(getEvents)
        XCTAssertTrue(getEvents?.count == 2)
    }
    
    func testUpdateEvent() {
        let trip = tripsController.addTrip(name: "Wedding",
                                   image: nil,
                                   startDate: nil,
                                   endDate: nil)

        let newEvent = tripsController.addEvent(name: "Dinner",
                                            eventDescription: nil,
                                            category: nil,
                                            latitude: nil,
                                            longitude: nil,
                                            startDate: nil,
                                            endDate: nil,
                                            notes: nil,
                                            trip: trip)
        
        newEvent.name = "Reception Party"
        let updatedEvent = tripsController.updateEvent(newEvent)
        
        XCTAssertTrue(newEvent.name == updatedEvent.name)
        XCTAssertTrue(updatedEvent.name == "Reception Party")
    }
    
    func testDeleteEvent() {
        let trip = tripsController.addTrip(name: "Wedding",
                                   image: nil,
                                   startDate: nil,
                                   endDate: nil)

        let newEvent = tripsController.addEvent(name: "Dinner",
                                            eventDescription: nil,
                                            category: nil,
                                            latitude: nil,
                                            longitude: nil,
                                            startDate: nil,
                                            endDate: nil,
                                            notes: nil,
                                            trip: trip)
        
        var fetchEvents = tripsController.getEvents()
        
        XCTAssertTrue(fetchEvents?.count == 1)
        XCTAssertTrue(newEvent.name == fetchEvents?.first?.name)
        
        tripsController.deleteEvent(newEvent)
        fetchEvents = tripsController.getEvents()
        
        XCTAssertTrue(fetchEvents?.isEmpty ?? false)
    }
}
