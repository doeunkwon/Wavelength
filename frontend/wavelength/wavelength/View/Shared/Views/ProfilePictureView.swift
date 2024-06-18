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
                .frame(width: frameSize, height: frameSize)
                .foregroundColor(color)
            Text(emoji)
                .font(.system(size: Fonts.icon))
        }
        .cornerRadius(8)
    }
}

#Preview {
    ProfilePictureView(emoji: "🌎", color: Color.wavelengthBlue, frameSize: FrameSizes.medium, emojiSize: Fonts.header)
}
