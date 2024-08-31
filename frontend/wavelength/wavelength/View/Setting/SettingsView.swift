//
//  Settings.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var settingsToast: Toast? = nil
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: Padding.large) {
            Text(Strings.general.settings)
                .font(.system(size: Fonts.title, weight: .semibold))
                .foregroundStyle(.wavelengthText)
            SettingsPanelView(isLoggedIn: $isLoggedIn, settingsToast: $settingsToast)
                .cornerRadius(CornerRadius.medium)
                .shadow(
                    color: ShadowStyle.standard.color,
                    radius: ShadowStyle.standard.radius,
                    x: ShadowStyle.standard.x,
                    y: ShadowStyle.standard.y)
            Spacer()
        }
        .padding(.horizontal, Padding.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.wavelengthBackground)
        .toast(toast: $settingsToast)
    }
}
