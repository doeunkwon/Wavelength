//
//  MemoryCellView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-08.
//

import SwiftUI

struct MemoryCellView: View {
    
    let title: String
    let content: String
    let tokens: Int
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: Padding.medium) {
                Text(title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthBlack)
                    .frame(height: 20)
                Text(content)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthDarkGrey)
                    .frame(height: 40)
                Text((tokens > 0 ? "+" : "") + String(tokens) + " " + Strings.general.tokens)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthTokenOrange)
            }
            .padding(Padding.large)
            .frame(maxWidth: .infinity)
            .background(.wavelengthOffWhite) // Set text color
            .cornerRadius(CornerRadius.medium) // Add corner radius
        }
    }
    
}

#Preview {
    MemoryCellView(title: "Text message during my Asia trip 2024 to Tokyo, Japan.", content: "He asked me to hang out after my Asia trip. I thought it was quite nice that he thought of me while I was on my trip because it’s easy to forget these things!", tokens: 2, action: {print("Memory cell tapped!")})
}
