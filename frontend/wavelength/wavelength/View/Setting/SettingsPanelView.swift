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
            SettingsCellView(title: Strings.settings.profile, icon: Strings.icons.person)
            Divider()
            SettingsCellView(title: Strings.settings.changePassword, icon: Strings.icons.lock)
            Divider()
            SettingsCellView(title: Strings.settings.deleteProfile, icon: Strings.icons.trash)
            Divider()
            SettingsCellView(title: Strings.settings.logOut, icon: Strings.icons.doorLeftHandOpen)
        }
    }
}

#Preview {
    SettingsPanelView()
}
