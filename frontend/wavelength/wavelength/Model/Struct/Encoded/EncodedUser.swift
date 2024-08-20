//
//  EncodedUser.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-19.
//

import SwiftUI

struct EncodedUser: Encodable, EncodedProfile {
    var emoji: String?
    var color: String? // Assuming color can be represented as a string on the backend
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?
    var password: String? // Consider not including password in the response for security reasons
    var goals: String?
    var interests: [String]?
    var values: [String]?
    var scorePercentage: Int?
    var tokenCount: Int?
    var memoryCount: Int?
}
 
