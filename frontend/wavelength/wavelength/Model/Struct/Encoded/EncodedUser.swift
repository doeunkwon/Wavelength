//
//  EncodedUser.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-19.
//

import SwiftUI

struct EncodedUser: Encodable {
    var emoji: String?
    let color: String? // Assuming color can be represented as a string on the backend
    let firstName: String?
    let lastName: String?
    let username: String?
    let email: String?
    let password: String? // Consider not including password in the response for security reasons
    let goals: String?
    let interests: [String]?
    let values: [String]?
    let scorePercentage: Int?
    let tokenCount: Int?
    let memoryCount: Int?
}
 
