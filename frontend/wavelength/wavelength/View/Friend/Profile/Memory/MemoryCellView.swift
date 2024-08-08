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
    
    var body: some View {
        VStack(alignment: .leading, spacing: Padding.medium) {
            Text(title)
                .font(.system(size: Fonts.body))
            Text(content)
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

#Preview {
    MemoryCellView(title: "Text message during my Asia trip 2024.", content: "He asked me to hang out after my Asia trip. I thought it was quite nice that he thought of me while I was on my trip because it’s easy to forget these things!", tokens: 2)
}
