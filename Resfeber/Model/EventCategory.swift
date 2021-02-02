//
//  EventCategory.swift
//  Resfeber
//
//  Created by David Wright on 12/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

public enum EventCategory: Int, CaseIterable {
        case notSpecified, accommodation, restaurant, entertainment, park, airport, retail, grocery, bank, gasStation, chargeStation, home, work, education, medical, pharmacy, emergency, hospital
}

extension EventCategory {
    
    static var displayNames = allCases.map { $0.displayName }
    
    var displayName: String? {
        switch self {
        case .notSpecified: return nil
        case .accommodation: return "Accommodation"
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
        case .accommodation: return UIImage(systemName: "bed.double.fill")
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
        case .notSpecified: return RFColor.primaryOrange
        case .accommodation: return RFColor.rgb(r: 153, g: 135, b: 255)
        case .restaurant: return RFColor.rgb(r: 248, g: 149, b: 64)
        case .entertainment: return RFColor.rgb(r: 229, g: 109, b: 214)
        case .park: return RFColor.rgb(r: 108, g: 193, b: 57)
        case .airport: return RFColor.rgb(r: 84, g: 155, b: 255)
        case .retail, .grocery: return RFColor.rgb(r: 255, g: 179, b: 0)
        case .bank: return RFColor.rgb(r: 111, g: 130, b: 179)
        case .gasStation: return RFColor.rgb(r: 29, g: 160, b: 255)
        case .chargeStation: return RFColor.rgb(r: 52, g: 199, b: 89)
        case .home: return RFColor.rgb(r: 0, g: 174, b: 239)
        case .work, .education: return RFColor.rgb(r: 166, g: 116, b: 73)
        case .medical, .pharmacy, .emergency, .hospital: return RFColor.rgb(r: 255, g: 93, b: 90)
        }
    }
}
