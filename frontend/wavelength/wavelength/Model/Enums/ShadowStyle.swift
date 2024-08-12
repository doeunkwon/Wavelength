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

    var color: Color {
        switch self {
        case .standard: return .shadowStandard
        case .subtle: return .shadowSubtle
        }
    }

    var radius: CGFloat {
        switch self {
        case .standard: return 8
        case .subtle: return 5
        }
    }

    var x: CGFloat {
        switch self {
        case .standard: return 0
        case .subtle: return 0
        }
    }

    var y: CGFloat {
        switch self {
        case .standard: return 4
        case .subtle: return 4
        }
    }
}
