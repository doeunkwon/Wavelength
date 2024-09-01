//
//  ShadowStyle.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI

enum ToastStyle {
  case error
  case warning
  case success
  case info
}

enum ShadowStyle {
    case high
    case low
    case glow(Color)

    var color: Color {
        switch self {
        case .high: return .shadowStandard
        case .low: return .shadowSubtle
        case .glow(let baseColor): return baseColor.opacity(0.5)
        }
    }

    var radius: CGFloat {
        switch self {
        case .high: return 10
        case .low: return 5
        case .glow: return 12
        }
    }

    var x: CGFloat {
        switch self {
        case .high: return 0
        case .low: return 0
        case .glow: return 0
        }
    }

    var y: CGFloat {
        switch self {
        case .high: return 12
        case .low: return 6
        case .glow: return 0
        }
    }
}
