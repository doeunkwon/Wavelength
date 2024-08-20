//
//  DecodedFriend.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import SwiftUI

struct DecodedFriend: Decodable {
    
    let fid: String
    let scorePercentage: Int
    let scoreAnalysis: String
    let emoji: String
    let color: String // Assuming color can be represented as a string on the backend
    let firstName: String
    let lastName: String
    let goals: String
    let interests: [String]
    let values: [String]
    let tokenCount: Int
    let memoryCount: Int

    enum CodingKeys: String, CodingKey {
        case fid
        case scorePercentage
        case scoreAnalysis
        case emoji
        case color
        case firstName
        case lastName
        case goals
        case interests
        case values
        case tokenCount
        case memoryCount
    }
}
