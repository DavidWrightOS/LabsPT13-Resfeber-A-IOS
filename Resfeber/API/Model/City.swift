//
//  City.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/18/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

/// Detailed information about a city.
/// `fullName` - The full name of the city, qualified with country and administrative division (if present)
/// `geonameID` - The GeoNames.org ID of the city
/// `location` - The coordinates of the city center
///` name` - The name of the city
/// `population` - The population estimate of the city
struct City: Codable {
    let links: Links
    let fullName: String
    let geonameID: Int
    let location: Location
    let name: String
    let population: Int
    
    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case fullName = "full_name"
        case geonameID = "geoname_id"
        case location, name, population
    }
}

/// Related resources about a city.
/// `cityAdmin1Division` resource: Admin1Division - The level 1 administrative division (e.g. state) that the city belongs to
/// `cityAlternateNames` resource: CityAlternateNames - The alternate names for the city
/// `cityCountry` resource: Country - The country that the city belongs to
/// `cityTimezone` resource: Timezone - The timezone of the city
/// `cityUrbanArea` resource: UrbanArea - The urban area that the city belongs toextension City {
extension City {
    struct Links: Codable {
        let cityAdmin1Division: CityAdmin1Division
        let cityAlternateNames: CityAlternateNames
        let cityCountry, cityTimezone, cityUrbanArea: CityAdmin1Division
        let linksSelf: CityAlternateNames
        
        enum CodingKeys: String, CodingKey {
            case cityAdmin1Division = "city:admin1_division"
            case cityAlternateNames = "city:alternate-names"
            case cityCountry = "city:country"
            case cityTimezone = "city:timezone"
            case cityUrbanArea = "city:urban_area"
            case linksSelf = "self"
        }
    }
    
    struct CityAdmin1Division: Codable {
        let href: String
        let name: String
    }
    
    struct CityAlternateNames: Codable {
        let href: String
    }

    struct Location: Codable {
        let geohash: String
        let latlon: Latlon
    }
    
    struct Latlon: Codable {
        let latitude, longitude: Double
    }
}




