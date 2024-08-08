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
            SettingsCellView(title: Strings.settings.profile, icon: Strings.icons.person, action: {print("Profile tapped!")})
            DividerLineView()
            SettingsCellView(title: Strings.settings.changePassword, icon: Strings.icons.lock, action: {print("Change Password tapped!")})
            DividerLineView()
            SettingsCellView(title: Strings.settings.deleteProfile, icon: Strings.icons.trash, action: {print("Delete Profile tapped!")})
            DividerLineView()
            SettingsCellView(title: Strings.settings.logOut, icon: Strings.icons.doorLeftHandOpen, action: {print("Log out tapped!")})
        }
    }
}

#Preview {
    SettingsPanelView()
}
