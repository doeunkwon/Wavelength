//
//  TrendColor.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-30.
//

import SwiftUI

enum TrendColor {
    static func from(value: String) -> Color {
        if value.isEmpty {
            return .gray // Or handle empty strings as needed
        }

        let firstCharacter = value.first!

        switch firstCharacter {
        case "+":
            return intToColor(value: 100)
        case "0":
            return intToColor(value: 50)
        case "-":
            return intToColor(value: 0)
        default:
            return .gray // Or handle other characters as needed
        }
    }
}
