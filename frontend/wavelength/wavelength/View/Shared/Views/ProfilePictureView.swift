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
    
    var body: some View {
        ZStack {
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: frameSize)
                .foregroundColor(color)
                .cornerRadius(CornerRadius.medium)
            Text(emoji)
                .font(.system(size: emojiSize))
        }
    }
}

#Preview {
    ProfilePictureView(emoji: "🌎", color: Color.wavelengthBlue, frameSize: Frame.medium, emojiSize: Fonts.header)
}
