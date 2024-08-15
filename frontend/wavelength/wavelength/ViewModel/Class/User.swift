//
//  User.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-14.
//

import SwiftUI

class User {
    
    let uid: String
    let emoji: String
    let color: Color
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let password: String
    let goals: String
    let interests: [String]
    let scorePercentage: Int
    let tokenCount: Int
    let memoryCount: Int
    let values: [String]
    
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
