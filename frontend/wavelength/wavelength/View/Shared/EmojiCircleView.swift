//
//  EmojiCircleView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI

struct EmojiCircleView: View {
    
    let emoji: String?
    let icon: String?
    
    init(emoji: String? = nil, icon: String? = nil) {
        self.emoji = emoji
        self.icon = icon
    }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: Frame.small)
                .foregroundColor(.wavelengthPurple)
                .opacity(0.2)
            if (emoji != nil) {
                Text(emoji ?? "😂")
            } else if (icon != nil) {
                Image(systemName: icon ?? Strings.icons.gear)
                    .font(.system(size: Fonts.subtitle))
                    .foregroundStyle(.wavelengthPurple)
                    .shadow(
                        color: .wavelengthPurple.opacity(0.5),
                        radius: ShadowStyle.standard.radius,
                        x: ShadowStyle.standard.x,
                        y: ShadowStyle.standard.y)
            }
        }
    }
}

#Preview {
    EmojiCircleView(icon: Strings.icons.gearshape)
}
