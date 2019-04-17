//
//  Person.swift
//  SprinklerController
//
//  Created by Roderic Campbell on 4/15/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import Foundation

public struct Person: Codable {
    public let fullname: String
    public let userID: String
    public let createDate: Int
    public let username: String
    public let email: String
    public let deleted: Bool
    public let devices: [Device]

    enum CodingKeys: String, CodingKey {
        case fullname = "fullName"
        case userID = "id"
        case createDate = "createDate"
        case username = "username"
        case email = "email"
        case deleted = "deleted"
        case devices = "devices"
    }
}
extension Person {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullname = try values.decode(String.self, forKey: .fullname)
        userID = try values.decode(String.self, forKey: .userID)
        createDate = try values.decode(Int.self, forKey: .createDate)
        username = try values.decode(String.self, forKey: .username)
        email = try values.decode(String.self, forKey: .email)
        deleted = try values.decode(Bool.self, forKey: .deleted)
        devices = try values.decode(Array.self, forKey: .devices)
    }
}
