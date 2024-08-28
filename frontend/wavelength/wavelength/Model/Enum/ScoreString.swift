//
//  ScoreString.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-28.
//

import SwiftUI

enum ScoreString: String {
    case veryLow = "very low"
    case low = "low"
    case medium = "medium"
    case high = "high"
    case veryHigh = "very high"

    static func from(value: Int) -> ScoreString {
        switch value {
        case 0...20:
            return .veryLow
        case 21...40:
            return .low
        case 41...60:
            return .medium
        case 61...80:
            return .high
        case 81...100:
            return .veryHigh
        default:
            return .veryLow // Or handle invalid values as needed
        }
    }
}
