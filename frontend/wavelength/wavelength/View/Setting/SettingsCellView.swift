//
//  SettingsCellView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI

struct SettingsCellView: View {
    
    let title: String
    let icon: String?
    
    init(title: String, icon: String?) {
        self.title = title
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            EmojiCircleView(icon: icon)
                .padding(.trailing, 2)
            Text(title)
                .font(.system(size: Fonts.body))
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

#Preview {
    SettingsCellView(title: Strings.settings.profile, icon: Strings.icons.person)
}
