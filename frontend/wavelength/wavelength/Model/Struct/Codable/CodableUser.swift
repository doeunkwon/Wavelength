//
//  CodableUser.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-09-25.
//

import SwiftUI

struct CodableUser: CodableProfile {
    var uid: String?
    var emoji: String?
    var color: String? // Assuming color can be represented as a string on the backend
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?
    var password: String? // Consider not including password in the response for security reasons
    var goals: String?
    var interests: [String]?
    var values: [String]?
    var scorePercentage: Int?
    var tokenCount: Int?
    var memoryCount: Int?

}
 
extension CodableUser: Codable {

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        self.color = try container.decode(String.self, forKey: .color)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.goals = try container.decode(String.self, forKey: .goals)
        self.interests = try container.decode([String].self, forKey: .interests)
        self.values = try container.decode([String].self, forKey: .values)
        self.scorePercentage = try container.decode(Int.self, forKey: .scorePercentage)
        self.tokenCount = try container.decode(Int.self, forKey: .tokenCount)
        self.memoryCount = try container.decode(Int.self, forKey: .memoryCount)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.emoji, forKey: .emoji)
        try container.encodeIfPresent(self.color, forKey: .color)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.username, forKey: .username)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.password, forKey: .password)
        try container.encodeIfPresent(self.goals, forKey: .goals)
        try container.encodeIfPresent(self.interests, forKey: .interests)
        try container.encodeIfPresent(self.values, forKey: .values)
        try container.encodeIfPresent(self.scorePercentage, forKey: .scorePercentage)
        try container.encodeIfPresent(self.tokenCount, forKey: .tokenCount)
        try container.encodeIfPresent(self.memoryCount, forKey: .memoryCount)
    }
    
    enum CodingKeys: String, CodingKey {
        case uid
        case emoji
        case color
        case firstName
        case lastName
        case username
        case email
        case password
        case goals
        case interests
        case values
        case scorePercentage
        case tokenCount
        case memoryCount
    }
    
}

