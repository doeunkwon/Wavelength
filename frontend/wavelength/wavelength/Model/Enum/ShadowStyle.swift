//
//  ShadowStyle.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI

enum ShadowStyle {
    case standard
    case subtle
    case glow(Color)

    var color: Color {
        switch self {
        case .standard: return .shadowStandard
        case .subtle: return .shadowSubtle
        case .glow(let baseColor): return baseColor.opacity(0.4)
        }
    }

    var radius: CGFloat {
        switch self {
        case .standard: return 8
        case .subtle: return 4
        case .glow: return 12
        }
    }

    var x: CGFloat {
        switch self {
        case .standard: return 0
        case .subtle: return 0
        case .glow: return 0
        }
    }

    var y: CGFloat {
        switch self {
        case .standard: return 6
        case .subtle: return 6
        case .glow: return 0
        }
    }
}
