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
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity) // Expand text to fill available width
                .padding(.vertical, Padding.large) // Add padding for spacing
        }
        .foregroundColor(color) // Set text color
        .background(.wavelengthOffWhite) // Set background color
        .cornerRadius(CornerRadius.medium) // Add corner radius
    }
}


#Preview {
    ButtonView(title: "2 memories", color: .wavelengthText, action: {print("Button pressed")})
}
