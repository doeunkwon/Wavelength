//
//  Friend.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-14.
//

import SwiftUI

class Friend: ObservableObject {
    
    let fid: String
    let scorePercentage: Int
    let scoreAnalysis: String
    let tokenCount: Int
    let memoryCount: Int
    @Published var emoji: String
    @Published var color: Color
    @Published var firstName: String
    @Published var lastName: String
    @Published var goals: String
    @Published var interests: [String]
    @Published var values: [String]
    
    func removeValueTag(tag: String) {
        values.removeAll { $0 == tag }
    }
    
    func removeInterestTag(tag: String) {
        interests.removeAll { $0 == tag }
    }
    
    init(fid: String, scorePercentage: Int, scoreAnalysis: String, tokenCount: Int, memoryCount: Int, emoji: String, color: Color, firstName: String, lastName: String, goals: String, interests: [String], values: [String]) {
        self.fid = fid
        self.scorePercentage = scorePercentage
        self.scoreAnalysis = scoreAnalysis
        self.tokenCount = tokenCount
        self.memoryCount = memoryCount
        self.emoji = emoji
        self.color = color
        self.firstName = firstName
        self.lastName = lastName
        self.goals = goals
        self.interests = interests
        self.values = values
    }
    
}
