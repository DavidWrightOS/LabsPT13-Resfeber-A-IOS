//
//  UrbanArea.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/18/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

/// Detailed information about an Urban Area
/// `boundingBox`  - Bounding box of the urban area
/// `continent` - The continent where the urban area is located
/// `fullName` - Full name of the urban area
/// `isGovernmentPartner` - Whether the urban_area represents a government partner to Teleport
/// `name`  - Name of the urban area
/// `slug` - Teleport Urban Area slug
/// `teleportCityURL` - Link to Teleport City Profile
/// `uaID`  - Teleport Urban Area ID
struct UrbanArea: Codable {
    let links: Links
    let boundingBox: BoundingBox
    let continent, fullName: String
    let isGovernmentPartner: Bool
    let name, slug: String
    let teleportCityURL: String
    let uaID: String

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case boundingBox = "bounding_box"
        case continent
        case fullName = "full_name"
        case isGovernmentPartner = "is_government_partner"
        case name, slug
        case teleportCityURL = "teleport_city_url"
        case uaID = "ua_id"
    }
}

/// Related resources about an Urban Area
/// `uaAdmin1Divisions` resource: Admin1Division - The level 1 administrative divisions that overlap the urban area
/// `uaCities` resource: UrbanAreaCityList - List of all cities belonging to the urban area
/// `uaContinent` resource: Continent - The continent the urban area is located on
/// `uaCountries`resource: Country - The countries that overlap the urban area
/// `uaDetails` resource: UrbanAreaDetails - The Teleport City details for the urban area
/// `uaIdentifyingCity` resource: City - The main city in the urban area (usually the city the urban area is named after)
/// `uaImages` resource: UrbanAreaImages - The Teleport City images for the urban area
/// `uaPrimaryCities` resource: City - The primary cities that make up the urban area
/// `uaSalaries` resource: UrbanAreaSalaries - Salary statistics for the urban area
/// `uaScores` resource: UrbanAreaScores - The Teleport City Scores for the urban area
extension UrbanArea {
    struct BoundingBox: Codable {
        let latlon: Latlon
    }

    struct Latlon: Codable {
        let east, north, south, west: Double
    }

    struct Links: Codable {
        let linksSelf: SelfURL
        let uaAdmin1Divisions: [UaURL]
        let uaCities: SelfURL
        let uaContinent: UaURL
        let uaCountries: [UaURL]
        let uaDetails: SelfURL
        let uaIdentifyingCity: UaURL
        let uaImages: SelfURL
        let uaPrimaryCities: [UaURL]
        let uaSalaries, uaScores: SelfURL

        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
            case uaAdmin1Divisions = "ua:admin1-divisions"
            case uaCities = "ua:cities"
            case uaContinent = "ua:continent"
            case uaCountries = "ua:countries"
            case uaDetails = "ua:details"
            case uaIdentifyingCity = "ua:identifying-city"
            case uaImages = "ua:images"
            case uaPrimaryCities = "ua:primary-cities"
            case uaSalaries = "ua:salaries"
            case uaScores = "ua:scores"
        }
    }

    struct SelfURL: Codable {
        let href: String
    }

    struct UaURL: Codable {
        let href: String
        let name: String
    }
}

