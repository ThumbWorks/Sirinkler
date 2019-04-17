//
//  Zone.swift
//  RachioModel
//
//  Created by Roderic Campbell on 4/15/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import Foundation

public struct Zone: Codable {
    public let zoneID: String
    public let name: String
    public let imageURLString: String
    enum CodingKeys: String, CodingKey {
        case zoneID = "id"
        case name = "name"
        case imageURLString = "imageUrl"
    }
}
extension Zone {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        zoneID = try values.decode(String.self, forKey: .zoneID)
        name = try values.decode(String.self, forKey: .name)
        imageURLString = try values.decode(String.self, forKey: .imageURLString)
    }
}
