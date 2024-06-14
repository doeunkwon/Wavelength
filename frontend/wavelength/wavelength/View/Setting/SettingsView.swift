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
                .cornerRadius(10)
                .shadow(color: Color(white: 0.0, opacity: 0.06), radius: 10, x: 0, y: 4)
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
