//
//  Settings.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var user: User
    
    @StateObject private var settingsToastManager = ToastManager()
    
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
                TabButtonView(selectedTab: $selectedTab, destinationTab: 1, icon: Strings.icons.squareGrid2by2, color: user.color)
            }
            SettingsPanelView(settingsToastManager: settingsToastManager, isLoggedIn: $isLoggedIn)
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
        .toast(toast: $settingsToastManager.toast)
    }
}
