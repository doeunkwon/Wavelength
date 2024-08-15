//
//  ProfilePictureView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-18.
//

import SwiftUI

struct ProfilePictureView: View {
    
    @EnvironmentObject var editedFriend: Friend
    
    let emoji: String
    let color: Color
    let frameSize: CGFloat
    let emojiSize: CGFloat
    let editable: Bool
    var shadowEnabled: Bool = true
    
    var body: some View {
        ZStack {
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: frameSize)
                .foregroundColor(editable ? editedFriend.color : color)
                .cornerRadius(CornerRadius.medium)
            Text(editable ? editedFriend.emoji : emoji)
                .font(.system(size: emojiSize))
        }
        .shadow(
            color: shadowEnabled ? ShadowStyle.glow(editable ? editedFriend.color : color).color : .clear,
            radius: shadowEnabled ? ShadowStyle.glow(editable ? editedFriend.color : color).radius : 0,
            x: shadowEnabled ? ShadowStyle.glow(editable ? editedFriend.color : color).x : 0,
            y: shadowEnabled ? ShadowStyle.glow(editable ? editedFriend.color : color).y : 0)
    }
}

#Preview {
    ProfilePictureView(emoji: "🌎", color: Color.wavelengthPurple, frameSize: Frame.medium, emojiSize: Fonts.header, editable: false)
}
