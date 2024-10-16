//
//  CodableBreakdown.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-09-25.
//

import SwiftUI

struct CodableBreakdown {
    
    var bid: String?
    var goal: Int?
    var value: Int?
    var interest: Int?
    var memory: Int?
    
}

extension CodableBreakdown: Codable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bid = try container.decode(String.self, forKey: .bid)
        self.goal = try container.decode(Int.self, forKey: .goal)
        self.value = try container.decode(Int.self, forKey: .value)
        self.interest = try container.decode(Int.self, forKey: .interest)
        self.memory = try container.decode(Int.self, forKey: .memory)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.goal, forKey: .goal)
        try container.encodeIfPresent(self.value, forKey: .value)
        try container.encodeIfPresent(self.interest, forKey: .interest)
        try container.encodeIfPresent(self.memory, forKey: .memory)
    }
    
    enum CodingKeys: String, CodingKey {
        case bid
        case goal
        case value
        case interest
        case memory
    }
    
}
