//
//  DecodedUser.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import SwiftUI

struct DecodedUser: Decodable {
    
    let uid: String
    let emoji: String
    let color: String // Assuming color can be represented as a string on the backend
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let password: String // Consider not including password in the response for security reasons
    let goals: String
    let interests: [String]
    let values: [String]
    let scorePercentage: Int
    let tokenCount: Int
    let memoryCount: Int

    enum CodingKeys: String, CodingKey {
        case uid
        case emoji
        case color
        case firstName
        case lastName
        case username
        case email
        case password
        case goals
        case interests
        case values
        case scorePercentage
        case tokenCount
        case memoryCount
    }
}

//Usage

//let decoder = JSONDecoder()
//if let decodedData = try? decoder.decode(DecodedUser.self, from: jsonData) {
//    let user = User(
//        uid: decodedData.uid,
//        emoji: decodedData.emoji,
//        color: Color(decodedData.color), // Assuming conversion from string
//        firstName: decodedData.firstName,
//        // ... (set other properties)
//    )
//}
