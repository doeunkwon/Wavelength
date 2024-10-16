//
//  CodableFriend.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-09-25.
//

import SwiftUI

struct CodableFriend: CodableProfile {
    
    var fid: String?
    var emoji: String?
    var color: String? // Assuming color can be represented as a string on the backend
    var firstName: String?
    var lastName: String?
    var goals: String?
    var interests: [String]?
    var values: [String]?
    var scorePercentage: Int?
    var scoreAnalysis: String?
    var tokenCount: Int?
    var memoryCount: Int?
    
}

extension CodableFriend: Codable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.scorePercentage = try container.decode(Int.self, forKey: .scorePercentage)
        self.scoreAnalysis = try container.decode(String.self, forKey: .scoreAnalysis)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        self.color = try container.decode(String.self, forKey: .color)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.goals = try container.decode(String.self, forKey: .goals)
        self.interests = try container.decode([String].self, forKey: .interests)
        self.values = try container.decode([String].self, forKey: .values)
        self.tokenCount = try container.decode(Int.self, forKey: .tokenCount)
        self.memoryCount = try container.decode(Int.self, forKey: .memoryCount)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.scorePercentage, forKey: .scorePercentage)
        try container.encodeIfPresent(self.scoreAnalysis, forKey: .scoreAnalysis)
        try container.encodeIfPresent(self.emoji, forKey: .emoji)
        try container.encodeIfPresent(self.color, forKey: .color)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.goals, forKey: .goals)
        try container.encodeIfPresent(self.interests, forKey: .interests)
        try container.encodeIfPresent(self.values, forKey: .values)
        try container.encodeIfPresent(self.tokenCount, forKey: .tokenCount)
        try container.encodeIfPresent(self.memoryCount, forKey: .memoryCount)
    }
    
    enum CodingKeys: String, CodingKey {
        case fid
        case scorePercentage
        case scoreAnalysis
        case emoji
        case color
        case firstName
        case lastName
        case goals
        case interests
        case values
        case tokenCount
        case memoryCount
    }
    
}
