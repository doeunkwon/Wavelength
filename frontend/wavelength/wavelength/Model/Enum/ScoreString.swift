//
//  ScoreString.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-28.
//

import SwiftUI

enum ScoreString: String {
    case veryLow = "very poorly"
    case low = "poorly"
    case medium = "decently"
    case high = "well"
    case veryHigh = "very well"

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
