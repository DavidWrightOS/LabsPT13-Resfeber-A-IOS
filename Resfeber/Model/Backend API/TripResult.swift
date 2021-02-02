//
//  TripResult.swift
//  Resfeber
//
//  Created by David Wright on 1/21/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

struct TripResult: Codable {
    let serverID: Int?
    var userID: String?
    let name: String
    let imageURL: String?
    
    init(serverID: Int? = nil, userID: String? = nil, name: String? = nil, imageURL: String? = nil, events: [EventResult]? = nil) {
        self.serverID = serverID
        self.userID = userID
        self.name = name ?? ""
        self.imageURL = imageURL
    }
    
    enum EncodingKeys: String, CodingKey {
        case serverID = "trip_id"
        case userID = "user_id"
        case name = "trip_name"
        case imageURL = "img_url"
    }
    
    enum DecodingKeys: String, CodingKey {
        case serverID = "id"
        case userID = "user_id"
        case name = "trip_name"
        case imageURL = "img_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        self.serverID = try container.decode(Int?.self, forKey: .serverID)
        self.userID = try container.decode(String?.self, forKey: .userID)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageURL = try container.decode(String?.self, forKey: .imageURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(serverID, forKey: .serverID)
        try container.encode(userID, forKey: .userID)
        try container.encode(name, forKey: .name)
        try container.encode(imageURL, forKey: .imageURL)
    }
}

extension TripResult: CustomStringConvertible {
    var description: String {
        "TripResult(name: \"\(name)\")"
    }
}
