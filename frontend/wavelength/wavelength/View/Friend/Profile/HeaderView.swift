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
        HStack(alignment: .center) {
            ProfilePictureView(emoji: emoji, color: color, frameSize: Frame.medium, emojiSize: Fonts.header, shadowEnabled: false)
            VStack(alignment: .leading) {
                Text(firstName + " " + lastName)
                    .font(.system(size: Fonts.subtitle))
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(Strings.Dashboard.tokens(str: (tokenCount > 0 ? "+" : "") + String(tokenCount)))
                    .font(.system(size: Fonts.body))
                    .foregroundStyle(.wavelengthTokenOrange)
            }
            .padding(.leading, Padding.medium)
        }
    }
}
