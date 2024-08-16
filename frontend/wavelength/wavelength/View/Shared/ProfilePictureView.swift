//
//  ProfilePictureView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-18.
//

import SwiftUI

struct ProfilePictureView: View {
    
    let emoji: String
    let color: Color
    let frameSize: CGFloat
    let emojiSize: CGFloat
    var shadowEnabled: Bool = true
    
    var body: some View {
        ZStack {
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: frameSize)
                .foregroundColor(color)
                .cornerRadius(CornerRadius.medium)
            if emoji.count == 0 && emojiSize == Fonts.icon {
                Text(Strings.form.tapToEdit)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthGrey)
            } else {
                Text(emoji)
                    .font(.system(size: emojiSize))
            }

        }
        .shadow(
            color: shadowEnabled ? ShadowStyle.glow(color).color : .clear,
            radius: shadowEnabled ? ShadowStyle.glow(color).radius : 0,
            x: shadowEnabled ? ShadowStyle.glow(color).x : 0,
            y: shadowEnabled ? ShadowStyle.glow(color).y : 0)
    }
}

#Preview {
    ProfilePictureView(emoji: "🌎", color: Color.wavelengthPurple, frameSize: Frame.medium, emojiSize: Fonts.header)
}
