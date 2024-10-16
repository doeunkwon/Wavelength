//
//  ScoreString.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-28.
//

import SwiftUI

enum ScoreString: String {
    case rank10 = "worlds apart"
    case rank9 = "a long way off"
    case rank8 = "out of sync"
    case rank7 = "on different paths"
    case rank6 = "halfway there"
    case rank5 = "on the right track"
    case rank4 = "on the same page"
    case rank3 = "a dynamic duo"
    case rank2 = "two peas in a pod"
    case rank1 = "on the same wavelength"


    static func from(value: Int) -> ScoreString {
        switch value {
        case 0...10:
            return .rank10
        case 11...20:
            return .rank9
        case 21...30:
            return .rank8
        case 31...40:
            return .rank7
        case 41...50:
            return .rank6
        case 51...60:
            return .rank5
        case 61...70:
            return .rank4
        case 71...80:
            return .rank3
        case 81...90:
            return .rank2
        case 91...100:
            return .rank1
        default:
            return .rank5 // Or handle invalid values as needed
        }
    }
}
