//
//  Photo.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/18/20.
//  Copyright © 2020 Joshua Rutkowski. All rights reserved.
//

import Foundation

/// Images for an urban area
/// Accessed from urban area slug URL, ex:
/// "https://api.teleport.org/api/urban_areas/slug:san-francisco-bay-area/images/"
/// `photos` Photo(object)[] - List of photos
struct Photo: Codable {
    let links: Links
    let photos: [PhotoElement]

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case photos
    }
}

extension Photo {
    struct Links: Codable {
        let linksSelf: linksURL

        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
        }
    }

    struct linksURL: Codable {
        let href: String
    }

    struct PhotoElement: Codable {
        let attribution: Attribution
        let image: Image
    }

    struct Attribution: Codable {
        let license, photographer, site: String
        let source: String
    }

    struct Image: Codable {
        let mobile, web: String
    }

}

