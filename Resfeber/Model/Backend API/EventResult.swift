//
//  EventResult.swift
//  Resfeber
//
//  Created by David Wright on 1/21/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

struct EventResult: Codable {
    let serverID: Int?
    let userID: String?
    let tripServerID: Int?
    let name: String
    let date: String?
    let latitude: String?
    let longitude: String?
    let notes: String?
    let imageURL: String?
    
    init(serverID: Int? = nil, userID: String? = nil, tripServerID: Int? = nil, name: String? = nil, date: String? = nil, latitude: String? = nil, longitude: String? = nil, notes: String? = nil, imageURL: String? = nil) {
        self.serverID = serverID
        self.userID = userID
        self.tripServerID = tripServerID
        self.name = name ?? ""
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.notes = notes
        self.imageURL = imageURL
    }
    
    enum EncodingKeys: String, CodingKey {
        case serverID = "item_id"
        case userID = "user_id"
        case tripServerID = "trip_id"
        case name = "item_name"
        case date
        case latitude = "lat"
        case longitude = "lon"
        case notes = "notes"
        case imageURL = "img_url"
    }
    
    enum DecodingKeys: String, CodingKey {
        case serverID = "id"
        case userID = "user_id"
        case tripServerID = "trip_id"
        case name = "item_name"
        case date
        case latitude = "lat"
        case longitude = "lon"
        case notes = "notes"
        case imageURL = "img_url"
    }
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        self.serverID = try container.decode(Int?.self, forKey: .serverID)
        self.userID = try container.decode(String?.self, forKey: .userID)
        self.tripServerID = try container.decode(Int?.self, forKey: .tripServerID)
        self.name = try container.decode(String.self, forKey: .name)
        self.date = try container.decode(String?.self, forKey: .date)
        self.latitude = try container.decode(String?.self, forKey: .latitude)
        self.longitude = try container.decode(String?.self, forKey: .longitude)
        self.notes = try container.decode(String?.self, forKey: .notes)
        self.imageURL = try container.decode(String?.self, forKey: .imageURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(serverID, forKey: .serverID)
        try container.encode(userID, forKey: .userID)
        try container.encode(tripServerID, forKey: .tripServerID)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(notes, forKey: .notes)
        try container.encode(imageURL, forKey: .imageURL)
    }
}

extension EventResult: CustomStringConvertible {
    var description: String {
        if let serverID = serverID {
            return "EventResult(name: \"\(name)\", serverID: \(serverID))"
        }
        return "EventResult(name: \"\(name)\", serverID: nil)"
    }
}
