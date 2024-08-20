//
//  EncodedFriend.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-19.
//

import SwiftUI

struct EncodedFriend: Encodable {
    let emoji: String?
    let color: String? // Assuming color can be represented as a string on the backend
    let firstName: String?
    let lastName: String?
    let goals: String?
    let interests: [String]?
    let values: [String]?
    let scorePercentage: Int?
    let scoreAnalysis: String?
    let tokenCount: Int?
    let memoryCount: Int?
}
