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

}
