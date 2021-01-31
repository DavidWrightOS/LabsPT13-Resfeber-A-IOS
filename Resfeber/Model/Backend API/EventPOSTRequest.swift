//
//  EventPOSTRequest.swift
//  Resfeber
//
//  Created by David Wright on 1/21/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

struct EventPOSTRequest: Codable {
    let userID: String?
    let tripServerID: Int?
    let name: String
    let date: String?
    let latitude: String?
    let longitude: String?
    let notes: String?
    let imageURL: String?
    
    init(userID: String? = nil, tripServerID: Int? = nil, name: String? = nil, date: String? = nil, latitude: String? = nil, longitude: String? = nil, notes: String? = nil, imageURL: String? = nil) {
        self.userID = userID
        self.tripServerID = tripServerID
        self.name = name ?? ""
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.notes = notes
        self.imageURL = imageURL
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case tripServerID = "trip_id"
        case name = "item_name"
        case date
        case latitude = "lat"
        case longitude = "lon"
        case notes = "notes"
        case imageURL = "img_url"
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M-d-yyyy H:m:s"
        return formatter
    }()
}

extension EventPOSTRequest: CustomStringConvertible {
    var description: String {
        "EventResult(name: \"\(name)\", eventID: nil)"
    }
}
