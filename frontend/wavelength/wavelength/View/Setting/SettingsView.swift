//
//  Settings.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            SettingsPanelView()
                .cornerRadius(CornerRadius.medium)
                .shadow(
                    color: ShadowStyle.standard.color,
                    radius: ShadowStyle.standard.radius,
                    x: ShadowStyle.standard.x,
                    y: ShadowStyle.standard.y)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.wavelengthBackground)
    }
}

#Preview {
    SettingsView()
}
