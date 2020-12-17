//
//  EventCategory.swift
//  Resfeber
//
//  Created by David Wright on 12/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

public enum EventCategory: Int, CaseIterable {
        case notSpecified, accomodation, restaurant, entertainment, park, airport, retail, grocery, bank, gasStation, chargeStation, home, work, education, medical, pharmacy, emergency, hospital
}

extension EventCategory {
    
    var displayName: String? {
        switch self {
        case .notSpecified: return nil
        case .accomodation: return "Accomodation"
        case .restaurant: return "Restaurant"
        case .entertainment: return "Entertainment"
        case .park: return "Park"
        case .airport: return "Airport"
        case .retail: return "Retail"
        case .grocery: return "Grocery"
        case .bank: return "Bank"
        case .gasStation: return "Gas Station"
        case .chargeStation: return "Charge Station"
        case .home: return "Home"
        case .work: return "Work"
        case .education: return "Education"
        case .medical: return "Medical"
        case .pharmacy: return "Pharmacy"
        case .emergency: return "Emergency"
        case .hospital: return "Hospital"
        }
    }
    
    var annotationGlyph: UIImage? {
        switch self {
        case .notSpecified: return UIImage(systemName: "mappin")
        case .accomodation: return UIImage(systemName: "bed.double.fill")
        case .restaurant: return UIImage(named: "forkandknife")
        case .entertainment: return UIImage(systemName: "star.fill")
        case .park: return UIImage(systemName: "leaf.fill")
        case .airport: return UIImage(systemName: "airplane")
        case .retail: return UIImage(systemName: "bag.fill")
        case .grocery: return UIImage(systemName: "cart.fill")
        case .bank: return UIImage(systemName: "building.columns")
        case .gasStation: return UIImage(systemName: "car.fill")
        case .chargeStation: return UIImage(systemName: "bolt.car.fill")
        case .home: return UIImage(systemName: "house.fill")
        case .work: return UIImage(systemName: "briefcase.fill")
        case .education: return UIImage(systemName: "graduationcap.fill")
        case .medical: return UIImage(systemName: "stethoscope")
        case .pharmacy: return UIImage(systemName: "pills.fill")
        case .emergency: return UIImage(systemName: "staroflife.fill")
        case .hospital: return UIImage(systemName: "cross.fill")
        }
    }
    
    /// Colors selected to match category colors used in Apple Maps
    var annotationMarkerTintColor: UIColor {
        switch self {
        case .notSpecified: return  #colorLiteral(red: 1, green: 0.3176634908, blue: 0.1177343801, alpha: 1)
        case .accomodation: return #colorLiteral(red: 0.5999641418, green: 0.5294604897, blue: 0.9998784661, alpha: 1)
        case .restaurant: return #colorLiteral(red: 0.9725401998, green: 0.5843424201, blue: 0.2509849072, alpha: 1)
        case .entertainment: return #colorLiteral(red: 0.8980445862, green: 0.4274922609, blue: 0.8391190767, alpha: 1)
        case .park: return #colorLiteral(red: 0.4233551323, green: 0.7568985224, blue: 0.2234918475, alpha: 1)
        case .airport: return #colorLiteral(red: 0.3292687535, green: 0.6078915, blue: 0.9998760819, alpha: 1)
        case .retail, .grocery: return #colorLiteral(red: 0.9999757409, green: 0.701993525, blue: 0.000208069614, alpha: 1)
        case .bank: return #colorLiteral(red: 0.4352324307, green: 0.5098394752, blue: 0.7018731236, alpha: 1)
        case .gasStation: return #colorLiteral(red: 0.1132080629, green: 0.627499342, blue: 0.9998752475, alpha: 1)
        case .chargeStation: return #colorLiteral(red: 0.2034551501, green: 0.7804297805, blue: 0.34896487, alpha: 1)
        case .home: return #colorLiteral(red: 0, green: 0.6823994517, blue: 0.9371369481, alpha: 1)
        case .work, .education: return #colorLiteral(red: 0.6509636641, green: 0.4549258351, blue: 0.286247611, alpha: 1)
        case .medical, .pharmacy, .emergency, .hospital: return #colorLiteral(red: 1, green: 0.3647276163, blue: 0.3529253006, alpha: 1)
        }
    }
}
