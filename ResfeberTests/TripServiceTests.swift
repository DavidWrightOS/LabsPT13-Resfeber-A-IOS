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
    
    
}
