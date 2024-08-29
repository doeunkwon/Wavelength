//
//  Score.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-18.
//

import SwiftUI

class Score: Hashable, Equatable {
    
    let sid: String
    let timestamp: Date
    let percentage: Int
    let breakdown: [Int]?
    let analysis: String?
    
    static func == (lhs: Score, rhs: Score) -> Bool {
      return lhs.sid == rhs.sid && lhs.timestamp == rhs.timestamp && lhs.percentage == rhs.percentage
             && lhs.analysis == rhs.analysis
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sid)
    }
    
    init(sid: String, timestamp: Date, percentage: Int, breakdown: [Int]? = nil, analysis: String? = nil) {
        self.sid = sid
        self.timestamp = timestamp
        self.percentage = percentage
        self.breakdown = breakdown
        self.analysis = analysis
    }
}
