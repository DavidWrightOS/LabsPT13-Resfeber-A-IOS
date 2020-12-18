//
//  Trip+CoreDataClass.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {

}

extension Trip {
    @discardableResult
    convenience init(name: String, image: Data?, startDate: Date?, endDate: Date?, id: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.image = image
        self.startDate = startDate
        self.endDate = endDate
    }
}
