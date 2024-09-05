//
//  ToastView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-30.
//

import SwiftUI

struct ToastView: View {
  
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)

    var body: some View {
        HStack(alignment: .center, spacing: Padding.medium) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.themeColor)
                .shadow(
                    color: ShadowStyle.glow(style.themeColor).color,
                    radius: ShadowStyle.glow(style.themeColor).radius,
                    x: ShadowStyle.glow(style.themeColor).x,
                    y: ShadowStyle.glow(style.themeColor).y)
            Text(message)
                .foregroundColor(.wavelengthText)

            Spacer()

            Button {
                onCancelTapped()
            } label: {
                Image(systemName: Strings.icons.xmark)
                    .foregroundColor(.wavelengthGrey)
            }
        }
        .font(.system(size: Fonts.body))
        .padding(Padding.large)
        .frame(width: width)
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(style.themeColor, lineWidth: Border.medium)
        )
        .background(.wavelengthLightGrey)
        .opacity(0.95)
        .cornerRadius(CornerRadius.medium)
    }
}

#Preview {
    ToastView(style: .success, message: "hi", width: Frame.toastWidth, onCancelTapped: {})
}
