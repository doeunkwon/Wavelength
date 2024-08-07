//
//  Mock.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-07.
//

import SwiftUI

enum Mock {
    static let friends: [Friend] = [
        Friend(emoji: "📀", color: Color.wavelengthYellow, uid: "1", firstName: "Kael", lastName: "Ramirez", goals: "He aspires to become a renowned architect, designing innovative and sustainable structures that shape the urban landscape. Additionally, Kael seeks to master the art of photography, capturing the beauty of the world through his lens.", interests: ["Architecture", "Photography", "Technology", "Music"], scorePercentage: 75, scoreAnalysis: "", tokenCount: 12, memoryCount: 67, values: ["Discipline": 76, "Integrity": 91, "Growth": 66, "Positivity": 82]),
        Friend(emoji: "👽", color: Color.wavelengthViolet, uid: "2", firstName: "Jasper", lastName: "Chen", goals: "Jasper dreams of creating groundbreaking software solutions that revolutionize industries. He is driven by a passion for coding and problem-solving, and aims to become a leading figure in the tech world.", interests: ["Coding", "Gaming", "Science Fiction", "Music", "Racing", "Travelling"], scorePercentage: 82, scoreAnalysis: "", tokenCount: -5, memoryCount: 23, values: ["Discipline": 78, "Integrity": 88, "Growth": 92, "Positivity": 91]),
        Friend(emoji: "🤖", color: Color.wavelengthBlue, uid: "3", firstName: "Orion", lastName: "Patel", goals: "With a deep love for storytelling, Orion aspires to write captivating novels that transport readers to different worlds. He seeks to develop his writing craft and share his unique perspective with the world.", interests: ["Writing", "Reading", "Philosophy", "AI", "Quantum Computing", "Bouldering", "Cooking", "Coffee"], scorePercentage: 68, scoreAnalysis: "Amazing friendship!", tokenCount: 18, memoryCount: 45, values: ["Discipline": 56, "Integrity": 66, "Growth": 93, "Positivity": 60  ])
    ]
}
