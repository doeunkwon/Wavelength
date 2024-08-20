//
//  EncodedFriend.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-19.
//

import SwiftUI

struct EncodedFriend: Encodable, EncodedProfile {
    var fid: String?
    var emoji: String?
    var color: String? // Assuming color can be represented as a string on the backend
    var firstName: String?
    var lastName: String?
    var goals: String?
    var interests: [String]?
    var values: [String]?
    var scorePercentage: Int?
    var scoreAnalysis: String?
    var tokenCount: Int?
    var memoryCount: Int?
}
