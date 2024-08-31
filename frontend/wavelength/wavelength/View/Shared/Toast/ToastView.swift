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
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.themeColor)
            Text(message)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthText)

            Spacer(minLength: 10)

            Button {
                onCancelTapped()
            } label: {
                Image(systemName: Strings.icons.xmark)
                    .foregroundColor(.wavelengthGrey)
            }
        }
        .padding(Padding.medium + Padding.nudge)
        .frame(minWidth: 0, maxWidth: width)
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
