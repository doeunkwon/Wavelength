//
//  CodableMemory.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-09-25.
//

import SwiftUI

struct CodableMemory {
    
    var mid: String?
    var date: String?
    var title: String?
    var content: String?
    var tokens: Int?
    
}

extension CodableMemory: Codable {
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mid = try container.decode(String.self, forKey: .mid)
        self.date = try container.decode(String.self, forKey: .date)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        self.tokens = try container.decode(Int.self, forKey: .tokens)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.date, forKey: .date)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.content, forKey: .content)
        try container.encodeIfPresent(self.tokens, forKey: .tokens)
    }
    
    enum CodingKeys: String, CodingKey {
        case mid
        case date
        case title
        case content
        case tokens
    }
    
}
