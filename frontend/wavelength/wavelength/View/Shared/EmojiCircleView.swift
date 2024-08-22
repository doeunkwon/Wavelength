//
//  EmojiCircleView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI

struct EmojiCircleView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    private var user: User {
        return viewModel.user
    }
    
    let icon: String
    let isEmoji: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: Frame.small)
                .foregroundColor(user.color)
                .opacity(0.1)
            if isEmoji {
                Text(icon)
            } else {
                Image(systemName: icon)
                    .font(.system(size: Fonts.subtitle))
                    .foregroundStyle(user.color)
                    .shadow(
                        color: ShadowStyle.glow(.wavelengthPurple).color,
                        radius: ShadowStyle.glow(.wavelengthPurple).radius,
                        x: ShadowStyle.glow(.wavelengthPurple).x,
                        y: ShadowStyle.glow(.wavelengthPurple).y)
            }
        }
    }
}

#Preview {
    EmojiCircleView(icon: Strings.icons.gearshape, isEmoji: false)
        .environmentObject(ViewModel())
}
