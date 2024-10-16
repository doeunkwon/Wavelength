//
//  Mock.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-07.
//

import SwiftUI

enum Mock {
    
    // MARK: - User

    static let user: User = User(uid: "2", emoji: "🚀", color: .green, firstName: "Alex", lastName: "Johnson", username: "alexjohnson", email: "alexj@example.com", password: "Xyz789", goals: "I want to create a non-profit organization focused on providing clean energy solutions to underserved areas. My passion for technology also drives me to develop innovative products that enhance daily life.", interests: ["Renewable Energy", "Robotics", "Hiking", "Cycling", "Electronic Music", "Traveling"], scorePercentage: 78, tokenCount: 40, memoryCount: 110, values: ["Innovation", "Sustainability", "Compassion", "Efficiency", "Adventure", "Balance"])

    // MARK: - Friend

    static let friend: Friend = Friend(fid: "4", scorePercentage: 88, scoreAnalysis: "", tokenCount: 22, memoryCount: 90, emoji: "🌟", color: .red, firstName: "Taylor", lastName: "Nguyen", goals: "Taylor dreams of becoming a world-class chef, specializing in fusion cuisine that combines flavors from different cultures. Additionally, Taylor is passionate about fitness and aims to compete in triathlons.", interests: ["Cooking", "Fitness", "Traveling", "Music Production"], values: ["Creativity", "Discipline", "Perseverance", "Health", "Culture"])

    static let friends: [Friend] = [
        Friend(fid: "4", scorePercentage: 88, scoreAnalysis: "", tokenCount: 22, memoryCount: 90, emoji: "🌟", color: .red, firstName: "Taylor", lastName: "Nguyen", goals: "Taylor dreams of becoming a world-class chef, specializing in fusion cuisine that combines flavors from different cultures. Additionally, Taylor is passionate about fitness and aims to compete in triathlons.", interests: ["Cooking", "Fitness", "Traveling", "Music Production"], values: ["Creativity", "Discipline", "Perseverance", "Health", "Culture"]),
        Friend(fid: "5", scorePercentage: 67, scoreAnalysis: "", tokenCount: 15, memoryCount: 30, emoji: "🌊", color: .blue, firstName: "Jordan", lastName: "Lee", goals: "Jordan seeks to explore the depths of the ocean, combining their love for marine biology with underwater photography. They also aim to educate people about marine conservation through storytelling.", interests: ["Marine Biology", "Photography", "Environmentalism", "Diving"], values: ["Curiosity", "Conservation", "Adventure", "Education"]),
        Friend(fid: "6", scorePercentage: 41, scoreAnalysis: "", tokenCount: 8, memoryCount: 60, emoji: "⚡️", color: .orange, firstName: "Blake", lastName: "Wright", goals: "Blake aims to revolutionize the world of digital marketing by developing tools that simplify data-driven strategies. He also dreams of becoming a professional e-sports competitor in his free time.", interests: ["Digital Marketing", "E-Sports", "Data Science", "Basketball"], values: ["Innovation", "Competition", "Growth", "Resilience"]),
    ]

    // MARK: - Memory

    static let memory1: Memory = Memory(mid: "3", date: Date(), title: "Surprise road trip to the mountains.", content: "Taylor surprised me with a spontaneous road trip to the mountains. We hiked to a stunning waterfall, and it was the perfect break from the usual routine.", tokens: 3)

    static let memory2: Memory = Memory(mid: "4", date: Date(), title: "Celebrating my promotion.", content: "Jordan threw a surprise party to celebrate my promotion at work. The thoughtfulness of organizing such an event with all my friends meant the world to me.", tokens: 2)

    static let memories: [Memory] = [
        Memory(mid: "3", date: Date(), title: "Surprise road trip to the mountains.", content: "Taylor surprised me with a spontaneous road trip to the mountains. We hiked to a stunning waterfall, and it was the perfect break from the usual routine.", tokens: 3),
        Memory(mid: "4", date: Date(), title: "Celebrating my promotion.", content: "Jordan threw a surprise party to celebrate my promotion at work. The thoughtfulness of organizing such an event with all my friends meant the world to me.", tokens: 2)
    ]

    // MARK: - TagManager

    static let tagManager: TagManager = TagManager(values: ["Curiosity", "Adventure", "Growth", "Creativity"], interests: ["Hiking", "Diving", "Digital Marketing", "E-Sports", "Cooking", "Photography"])
    
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

