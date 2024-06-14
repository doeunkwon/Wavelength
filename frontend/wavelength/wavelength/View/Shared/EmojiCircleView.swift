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
                .frame(width: 40)
                .foregroundColor(.wavelengthPurple)
                .opacity(0.2)
            if (emoji != nil) {
                Text(emoji ?? "😂")
            } else if (icon != nil) {
                Image(systemName: icon ?? "gear")
                    .font(.system(size: Fonts.subtitle))
                    .foregroundStyle(.wavelengthPurple)
            }
        }
    }
}

#Preview {
    EmojiCircleView(icon: "gearshape")
}
