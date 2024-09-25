//
//  CodableScore.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-09-25.
//

import SwiftUI

struct CodableScore {
    
    var sid: String?
    var timestamp: String?
    var percentage: Int?
    var analysis: String?
    
}

extension CodableScore: Codable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sid = try container.decode(String.self, forKey: .sid)
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.percentage = try container.decode(Int.self, forKey: .percentage)
        self.analysis = try container.decodeIfPresent(String.self, forKey: .analysis)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.percentage, forKey: .percentage)
        try container.encodeIfPresent(self.analysis, forKey: .analysis)
    }
    
    enum CodingKeys: String, CodingKey {
        case sid
        case timestamp
        case percentage
        case analysis
    }
    
}
