//
//  TokenCountButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-31.
//

import SwiftUI

struct TokenCountButtonView: View {
    
    @Binding private var tokens: Int
    
    init(tokens: Binding<Int>) {
        self._tokens = tokens
    }
    
    var body: some View {
        ZStack (alignment: .center) {
            RoundedRectangle(cornerRadius: CornerRadius.max)
                .frame(width: 180, height: Frame.floatingButtonHeight)
                .foregroundColor(.wavelengthOffWhite)
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: CornerRadius.max)
                        .stroke(.wavelengthWhite, lineWidth: Border.small))
                .shadow(
                    color: ShadowStyle.high.color,
                    radius: ShadowStyle.high.radius,
                    x: ShadowStyle.high.x,
                    y: ShadowStyle.high.y)
            HStack (alignment: .center, spacing: Padding.large) {
                
                Button {
                    if tokens > -5 {
                        tokens -= 1
                    }
                } label: {
                    Image(systemName: Strings.Icons.chevronLeft)
                        .font(Font.body.weight(.semibold))
                        .foregroundColor(tokens <= -5 ? .wavelengthGrey : .wavelengthTokenOrange)
                }
                .disabled(tokens <= -5)
                
                Text((tokens > 0 ? "+" : "") + "\($tokens.wrappedValue) \(Strings.Dashboard.tokens)")
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthTokenOrange)
                
                Button {
                    if tokens < 5 {
                        tokens += 1
                    }
                } label: {
                    Image(systemName: Strings.Icons.chevronRight)
                        .font(Font.body.weight(.semibold))
                        .foregroundColor(tokens >= 5 ? .wavelengthGrey : .wavelengthTokenOrange)
                }
                .disabled(tokens >= 5)
            }
        }
    }
}
