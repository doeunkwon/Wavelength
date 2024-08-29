//
//  ButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI

struct ButtonView: View {
    let title: String
    let color: Color
    let backgroundColor: Color?
    let largeFont: Bool?
    let action: () -> Void
    
    init(title: String, color: Color, backgroundColor: Color? = .wavelengthOffWhite, largeFont: Bool? = false, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.backgroundColor = backgroundColor
        self.largeFont = largeFont
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: (largeFont ?? false) ? Fonts.subtitle : Fonts.body))
                .frame(maxWidth: .infinity) // Expand text to fill available width
                .padding(.vertical, Padding.large) // Add padding for spacing
        }
        .foregroundColor(color) // Set text color
        .background(backgroundColor) // Set background color
        .cornerRadius(CornerRadius.medium) // Add corner radius
    }
}
