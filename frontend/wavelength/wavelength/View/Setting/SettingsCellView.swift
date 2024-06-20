//
//  SettingsCellView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI

struct SettingsCellView: View {
    
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                EmojiCircleView(icon: icon)
                    .padding(.trailing, 2)
                Text(title)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthBlack)
                Spacer()
                Image(systemName: Strings.icons.arrowRight)
                    .font(.system(size: Fonts.subtitle))
                    .foregroundColor(.wavelengthGrey)
            }
            .padding(.horizontal)
            .frame(height: 80)
            .background(Color.wavelengthOffWhite)
        }
    }
}

#Preview {
    SettingsCellView(title: Strings.settings.profile, icon: Strings.icons.person, action: { print("hello") })
}
