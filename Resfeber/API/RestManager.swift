//
//  RestManager.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class RestManager {
    /// The Base URL for connecting with the Teleport json endpoint
    let baseURL = URL(string: "https://api.teleport.org/api")!
    
    /// The default Headers for connecting with the Teleport json endpoint
    var defaultHeaders = [
        "Accept" : "application/vnd.teleport.v1+json",
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    /// The endpoints used to connect to the Teleport API
    enum Endpoints {
        case citybyName(String)
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

// MARK: - Endpoints

extension RestManager.Endpoints {
    var url: URL {
        switch self {
        case .citybyName(let city):
            return .makeEndpoint("/cities/?search=\(city)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "/cities/?search=\(city)")
        case .citiesByID(let cityID):
            return .makeEndpoint("/cities/\(cityID)/")
        case .citiesAlternateNames(let cityName):
            return .makeEndpoint("/cities/\(cityName)/")
        case .urbanAreas:
            return .makeEndpoint("/urban_areas/")
        case .urbanAreasByID(let urbanAreaID):
            return .makeEndpoint("/urban_areas/\(urbanAreaID)/")
        case .urbanAreasCities(let urbanAreaID):
            return .makeEndpoint("/urban_areas/\(urbanAreaID)/cities/")
        case .urbanAreasDetails(let urbanAreaID):
            return .makeEndpoint("/urban_areas/\(urbanAreaID)/details/")
        case .urbanAreasImages(let urbanAreaID):
            return .makeEndpoint("/urban_areas/\(urbanAreaID)/images/")
        case .urbanAreasScores(let urbanAreaID):
            return .makeEndpoint("/urban_areas/\(urbanAreaID)/scores/")
        case .locationsByCoordinates(let coordinates):
            return .makeEndpoint("/locations/\(coordinates)/")
        }
    }
}

extension URL {
    /// Extension of URL to make endpoint from a specified URL and endpoint
    /// - Parameter endpoint: An API endpoint
    /// - Returns: baseURL and endpoint
    static func makeEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://api.teleport.org/api/\(endpoint)")!
    }
}



