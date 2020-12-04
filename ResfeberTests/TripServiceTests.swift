//
//  TripServiceTests.swift
//  TripServiceTests
//
//  Created by Joshua Rutkowski on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import XCTest
@testable import Resfeber
import CoreData

class TripServiceTests: XCTestCase {
    var tripService: TripService!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        tripService = TripService(managedObjectContext: coreDataStack.mainContext,
                                  coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        tripService = nil
        coreDataStack = nil
    }
    
    func testAddTrip() {
        let trip = tripService.add(name: "Wedding",
                                   image: nil,
                                   startDate: nil,
                                   endDate: nil)
        
        XCTAssertNotNil(trip, "Trip should not be nil")
        XCTAssert(trip.name == "Wedding")
    }
    
    /// Tests asynchronous saving
    func testContextIsSavedAfterAddingTrip() {
        // Creates the background context and new instance of TripService
        let derivedContext = coreDataStack.newDerivedContext()
        tripService = TripService(managedObjectContext: derivedContext,
                                  coreDataStack: coreDataStack)
        // Creates an expectation that sends a signal to the test case when Core Data stack sends a notification event
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.mainContext) { _ in
            return true
        }
        
        // Adds the trip
        derivedContext.perform {
            let trip = self.tripService.add(name: "Wedding",
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
        let newTrip = tripService.add(name: "Road Trip to California",
                                      image: nil,
                                      startDate: nil,
                                      endDate: nil)
        
        let getTrips = tripService.getTrips()
        
        XCTAssertNotNil(getTrips)
        XCTAssertTrue(getTrips?.count == 1)
        XCTAssertTrue(newTrip.name == getTrips?.first?.name)
    }
    
    func testUpdateTrip() {
        let newTrip = tripService.add(name: "Endor",
                                      image: nil,
                                      startDate: nil,
                                      endDate: nil)
        newTrip.name = "Hoth"
        let updatedTrip = tripService.update(newTrip)
        
        XCTAssertTrue(newTrip.name == updatedTrip.name)
        XCTAssertTrue(updatedTrip.name == "Hoth")
    }
    
    func testDeleteTrip() {
        let newTrip = tripService.add(name: "Naboo",
                                      image: nil,
                                      startDate: nil,
                                      endDate: nil)
        
        var fetchTrips = tripService.getTrips()
        
        XCTAssertTrue(fetchTrips?.count == 1)
        XCTAssertTrue(newTrip.name == fetchTrips?.first?.name)
        
        tripService.delete(newTrip)
        fetchTrips = tripService.getTrips()
        
        XCTAssertTrue(fetchTrips?.isEmpty ?? false)
    }
    
    func testAddEventsToTrip() {
        let trip = tripService.add(name: "Wedding", image: nil, startDate: nil, endDate: nil)
        let event = tripService.addEvent(name: "Dinner", eventDescription: nil, category: nil, latitude: nil, longitude: nil, startDate: nil, endDate: nil, notes: nil, trip: trip)
        
        XCTAssertNotNil(trip, "Trip should not be nil")
        XCTAssertNotNil(event, "Event should not be nil")
        XCTAssert(trip.name == "Wedding")
        XCTAssert(event.name == "Dinner")
        XCTAssertTrue(trip.events?.count == 1)
    }
}
