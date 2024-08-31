//
//  Toast.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-30.
//

import SwiftUI

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = Frame.toastWidth
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
      return lhs.style == rhs.style && lhs.message == rhs.message && lhs.duration == rhs.duration
             && lhs.width == rhs.width
    }
}

extension ToastStyle {
  var themeColor: Color {
    switch self {
    case .error: return .red
    case .warning: return .orange
    case .info: return .blue
    case .success: return .green
    }
  }
  
  var iconFileName: String {
    switch self {
    case .info: return "info.circle.fill"
    case .warning: return "exclamationmark.triangle.fill"
    case .success: return "checkmark.circle.fill"
    case .error: return "xmark.circle.fill"
    }
  }
}
