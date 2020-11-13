//
//  RestManager.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

/// Protocol used to construct API endpoint paths
protocol Path {
    var path : String { get }
}

class RestManager {
    /// The Base URL for connecting with the Teleport json endpoint
    let baseURL = URL(string: "https://api.teleport.org/api/")!
    
    /// The default Headers for connecting with the Teleport json endpoint
    var defaultHeaders = [
        "Accept" : "application/vnd.teleport.v1+json",
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    enum Endpoints {
        case cities
        case citiesByID(String)
        case citiesAlternateNames(String)
        case urbanAreas
        case urbanAreasByID(String)
        case urbanAreasCities(String)
        case urbanAreasDetails(String)
        case urbanAreasImages(String)
        case urbanAreasScores(String)
        case locationsByCoordinates(String)
    }
}
/// The endpoints (conforming to Path protocol) which are used to connect to the Teleport API
extension RestManager.Endpoints : Path {
    var path: String {
        switch self {
        case .cities:
            return "/cities/"
        case .citiesByID(let cityID):
            return "/cities/\(cityID)/"
        case .citiesAlternateNames(let cityName):
            return "/cities/\(cityName)/"
        case .urbanAreas:
            return "/urban_areas/"
        case .urbanAreasByID(let urbanAreaID):
            return "/urban_areas/\(urbanAreaID)/"
        case .urbanAreasCities(let urbanAreaID):
            return "/urban_areas/\(urbanAreaID)/cities/"
        case .urbanAreasDetails(let urbanAreaID):
            return "/urban_areas/\(urbanAreaID)/details/"
        case .urbanAreasImages(let urbanAreaID):
            return "/urban_areas/\(urbanAreaID)/images/"
        case .urbanAreasScores(let urbanAreaID):
            return "/urban_areas/\(urbanAreaID)/scores/"
        case .locationsByCoordinates(let coordinates):
            return "/locations/\(coordinates)/"
        }
    }
}



