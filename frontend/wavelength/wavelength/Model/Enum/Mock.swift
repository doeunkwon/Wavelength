//
//  Mock.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-07.
//

import SwiftUI

enum Mock {
    
    // MARK: - User
    
    static let user: User = User(uid: "1", emoji: "🌎", color: .blue, firstName: "Drew", lastName: "Kasey", username: "drewkasey", email: "drewkasey@gmail.com", password: "Abc123", goals: "I aspire to be an entrepreneur who builds clever apps that address underserved problems in society. I love working out my body so while I build out apps, I still want to achieve athletic milestones, like running a marathon and building a beautiful physique.", interests: ["Programming", "Designing", "Boxing", "Muay Thai", "Running", "EDM", "Nature"], scorePercentage: 63, tokenCount: 25, memoryCount: 135, values: ["Discipline", "Hardwork", "Growth", "Integrity", "Learning", "Positivity"])
    
    // MARK: - Friend
    
    static let friend: Friend = Friend(fid: "1", scorePercentage: 75, scoreAnalysis: "", tokenCount: 12, memoryCount: 67, emoji: "📀", color: .yellow, firstName: "Kael", lastName: "Ramirez", goals: "He aspires to become a renowned architect, designing innovative and sustainable structures that shape the urban landscape. Additionally, Kael seeks to master the art of photography, capturing the beauty of the world through his lens.", interests: ["Architecture", "Photography", "Technology", "Music"], values: ["Learning", "Growth", "Integrity", "Kindness", "Perspective"])
    
    static let friends: [Friend] = [
        Friend(fid: "1", scorePercentage: 75, scoreAnalysis: "", tokenCount: 12, memoryCount: 67, emoji: "📀", color: .yellow, firstName: "Kael", lastName: "Ramirez", goals: "He aspires to become a renowned architect, designing innovative and sustainable structures that shape the urban landscape. Additionally, Kael seeks to master the art of photography, capturing the beauty of the world through his lens.", interests: ["Architecture", "Photography", "Technology", "Music"], values: ["Learning", "Growth", "Integrity", "Kindness", "Perspective"]),
        Friend(fid: "2", scorePercentage: 82, scoreAnalysis: "", tokenCount: -5, memoryCount: 23, emoji: "👽", color: .purple, firstName: "Jasper", lastName: "Chen", goals: "Jasper dreams of creating groundbreaking software solutions that revolutionize industries. He is driven by a passion for coding and problem-solving, and aims to become a leading figure in the tech world.", interests: ["Coding", "Gaming", "Science Fiction", "Music", "Racing", "Travelling"], values: ["Money", "Status", "Growth", "Learning"]),
        Friend(fid: "3", scorePercentage: 34, scoreAnalysis: "", tokenCount: 18, memoryCount: 45, emoji: "🤖", color: .blue, firstName: "Orion", lastName: "Patel", goals: "With a deep love for storytelling, Orion aspires to write captivating novels that transport readers to different worlds. He seeks to develop his writing craft and share his unique perspective with the world.", interests: ["Writing", "Reading", "Philosophy", "AI", "Quantum Computing", "Bouldering", "Cooking", "Coffee"], values: ["Discipline", "Integrity", "Growth", "Positivity"]),
    ]
    
    // MARK: - Memory

    static let memory1: Memory = Memory(mid: "1", date: Date(), title: "Text message during my Africa trip 2024 to Nigeria.", content: "He asked me to hang out after my Africa trip. I thought it was quite nice that he thought of me while I was on my trip because it’s easy to forget these things!", tokens: 2)
    
    static let memory2: Memory = Memory(mid: "2", date: Date(), title: "Bought me a coffee.", content: "He’d already left the office when I realized I’d forgotten my wallet. Figuring I’d have to skip my usual coffee run, I was about to head back to my desk when he appeared in the doorway, grinning and holding out a steaming cup. It was a small gesture, but it made my day.", tokens: 1)
    
    static let memories: [Memory] = [
        Memory(mid: "1", date: Date(), title: "Text message during my Africa trip 2024 to Nigeria.", content: "He asked me to hang out after my Africa trip. I thought it was quite nice that he thought of me while I was on my trip because it’s easy to forget these things!", tokens: 2),
        Memory(mid: "2", date: Date(), title: "Bought me a coffee.", content: "He’d already left the office when I realized I’d forgotten my wallet. Figuring I’d have to skip my usual coffee run, I was about to head back to my desk when he appeared in the doorway, grinning and holding out a steaming cup. It was a small gesture, but it made my day.", tokens: 1)
    ]
    
    // MARK: - TagManager
    
    static let tagManager: TagManager = TagManager(values: ["Money", "Status", "Growth", "Learning"], interests: ["Writing", "Reading", "Philosophy", "AI", "Quantum Computing", "Bouldering", "Cooking", "Coffee"])
    
    // MARK: - Score
    
    static let scoreChartData: [ScoreData] = [
        ScoreData(entry: 1, value: 50),
        ScoreData(entry: 2, value: 52),
        ScoreData(entry: 3, value: 52),
        ScoreData(entry: 4, value: 56),
        ScoreData(entry: 5, value: 55),
        ScoreData(entry: 6, value: 58),
        ScoreData(entry: 7, value: 60),
        ScoreData(entry: 8, value: 60),
        ScoreData(entry: 9, value: 60),
        ScoreData(entry: 10, value: 60),
        ScoreData(entry: 11, value: 60),
        ScoreData(entry: 12, value: 60),
        ScoreData(entry: 13, value: 60),
        ScoreData(entry: 14, value: 60),
        ScoreData(entry: 15, value: 60),
        ScoreData(entry: 16, value: 60),
        ScoreData(entry: 17, value: 60),
        ScoreData(entry: 18, value: 60),
        ScoreData(entry: 19, value: 60),
        ScoreData(entry: 20, value: 60)
    ]

}

