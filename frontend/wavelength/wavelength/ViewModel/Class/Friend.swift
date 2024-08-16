//
//  Friend.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-14.
//

import SwiftUI

class Friend: ObservableObject, Profile {
    
    let fid: String
    @Published var emoji: String
    @Published var color: Color
    @Published var firstName: String
    @Published var lastName: String
    @Published var goals: String
    @Published var interests: [String]
    @Published var values: [String]
    @Published var scorePercentage: Int
    @Published var scoreAnalysis: String
    @Published var tokenCount: Int
    @Published var memoryCount: Int
    
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
