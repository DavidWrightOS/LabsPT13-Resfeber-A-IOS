//
//  TripPOSTRequest.swift
//  Resfeber
//
//  Created by David Wright on 1/21/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

struct TripPOSTRequest: Codable {
    var userID: String?
    let name: String
    let imageURL: String?
    let events: [EventResult]?
    
    init(userID: String? = nil, name: String? = nil, imageURL: String? = nil, events: [EventResult]? = nil) {
        self.userID = userID
        self.name = name ?? ""
        self.imageURL = imageURL
        self.events = events
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name = "trip_name"
        case imageURL = "img_url"
        case events = "items"
    }
}

extension TripPOSTRequest: CustomStringConvertible {
    var description: String {
        "TripResult(name: \"\(name)\", eventCount: \(events?.count ?? 0))"
    }
}
