//
//  Settings.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var user: User
    
    @State private var settingsToast: Toast? = nil
    
    @Binding var isLoggedIn: Bool
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack (alignment: .center, spacing: Padding.large) {
            ZStack (alignment: .trailing) {
                HStack {
                    Spacer()
                    Text(Strings.general.settings)
                        .font(.system(size: Fonts.subtitle, weight: .semibold))
                        .foregroundStyle(.wavelengthText)
                    Spacer()
                }
                HomeButtonView(selectedTab: $selectedTab, color: user.color)
            }
            SettingsPanelView(isLoggedIn: $isLoggedIn, settingsToast: $settingsToast)
                .cornerRadius(CornerRadius.medium)
                .shadow(
                    color: ShadowStyle.low.color,
                    radius: ShadowStyle.low.radius,
                    x: ShadowStyle.low.x,
                    y: ShadowStyle.low.y)
            Spacer()
        }
        .padding(.horizontal, Padding.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.wavelengthBackground)
        .toast(toast: $settingsToast)
    }
}
