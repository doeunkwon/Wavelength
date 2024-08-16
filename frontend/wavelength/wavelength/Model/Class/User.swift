//
//  User.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-14.
//

import SwiftUI

class User: ObservableObject, Profile {
    
    let uid: String
    @Published var emoji: String
    @Published var color: Color
    @Published var firstName: String
    @Published var lastName: String
    @Published var username: String
    @Published var email: String
    @Published var password: String
    @Published var goals: String
    @Published var interests: [String]
    @Published var values: [String]
    @Published var scorePercentage: Int
    @Published var tokenCount: Int
    @Published var memoryCount: Int
    
    init(uid: String, emoji: String, color: Color, firstName: String, lastName: String, username: String, email: String, password: String, goals: String, interests: [String], scorePercentage: Int, tokenCount: Int, memoryCount: Int, values: [String]) {
        self.uid = uid
        self.emoji = emoji
        self.color = color
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
        self.password = password
        self.goals = goals
        self.interests = interests
        self.scorePercentage = scorePercentage
        self.tokenCount = tokenCount
        self.memoryCount = memoryCount
        self.values = values
    }
    
}
