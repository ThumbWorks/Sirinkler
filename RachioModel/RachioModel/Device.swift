//
//  Device.swift
//  RachioModel
//
//  Created by Roderic Campbell on 4/15/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import Foundation


public struct Device: Codable {
    public let deviceID: String
    public let zones: [Zone]
    enum CodingKeys: String, CodingKey {
        case deviceID = "id"
        case zones = "zones"
    }
}

extension Device {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        deviceID = try values.decode(String.self, forKey: .deviceID)
        zones = try values.decode(Array.self, forKey: .zones)
    }
}
