//
//  SettingsPanelView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI

struct SettingsPanelView: View {
    var body: some View {
        VStack(spacing: 0) {
            SettingsCellView(title: "Profile", icon: "person")
            Divider()
            SettingsCellView(title: "Change password", icon: "lock")
            Divider()
            SettingsCellView(title: "Delete profile", icon: "trash")
            Divider()
            SettingsCellView(title: "Log out", icon: "door.left.hand.open")
        }
    }
}

#Preview {
    SettingsPanelView()
}
