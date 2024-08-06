//
//  HeaderView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct HeaderView: View {
    
    let emoji: String
    let color: Color
    let firstName: String
    let lastName: String
    let tokenCount: Int
    
    var body: some View {
        HStack {
            ProfilePictureView(emoji: emoji, color: color, frameSize: Frame.medium, emojiSize: Fonts.header)
            VStack(alignment: .leading) {
                Text(firstName + " " + lastName)
                    .font(.system(size: Fonts.subtitle))
                Text((tokenCount > 0 ? "+" : "") + String(tokenCount) + " tokens")
                    .font(.system(size: Fonts.body))
                    .foregroundStyle(.wavelengthTokenOrange)
            }
            .padding(.leading, Padding.medium)
        }
    }
}

#Preview {
    HeaderView(emoji: "🌎", color: Color.wavelengthBlue, firstName: "Doeun", lastName: "Kwon", tokenCount: 17)
}
